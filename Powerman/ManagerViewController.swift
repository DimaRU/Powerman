//
//  ManagerViewController.swift
//  Powerman
//
//  Created by Dmitriy Borovikov on 14.06.2021.
//

import Cocoa

class ManagerViewController: NSViewController {
    @IBOutlet weak var gridView: NSGridView!
    var powerman: PowermanNetwork?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear() {
        powerman = PowermanNetwork()
        gridView.isHidden = powerman == nil
    }

    override func viewDidAppear() {
        updatePowerStatus()
        updateNetworkStatus()
    }

    @IBAction func updateButtonPress(_ sender: Any) {
        updatePowerStatus()
        updateNetworkStatus()
    }

    private func updatePowerStatus() {
        powerman?.readState{ status in
            for i in status.indices {
                if let label = self.gridView.cell(atColumnIndex: 0, rowIndex: i).contentView as? NSTextField {
                    let name = status[i].0 + ":"
                    label.stringValue = name.isEmpty ? "Socket \(i+1):" : name
                }
                if let sw = self.gridView.cell(atColumnIndex: 1, rowIndex: i).contentView as? NSSwitch {
                    sw.state = status[i].1 ? .on: .off
                }
            }
        }

    }

    private func updateNetworkStatus() {
        let rezult = shellCommand("networksetup -getinfo  Ethernet | grep IPv6:")
        if rezult.1 == 0 {
            let ipv6State = rezult.0.split(separator: ":").last!.trimmingCharacters(in: .whitespacesAndNewlines)
            if let label = gridView.cell(atColumnIndex: 0, rowIndex: 5).contentView as? NSTextField {
                label.stringValue = "IPv6 (\(ipv6State)):"
            }
            if let sw = self.gridView.cell(atColumnIndex: 1, rowIndex: 5).contentView as? NSSwitch {
                sw.state = ipv6State == "Automatic" ? .on:.off
            }
        } else {
            gridView.row(at: 5).isHidden = true
        }
    }

    @IBAction func switchAction(_ sender: NSSwitch) {
        let i = sender.tag
        switch i {
        case 1...4:
            powerman?.setState(for: i, state: sender.state == .on)
        case 6:
            let arg = sender.state == .on ? "-setv6automatic" : "-setv6off"
            DispatchQueue.main.async {
                _ = shellCommand("networksetup \(arg) Ethernet")
                self.updateNetworkStatus()
            }
        default:
            break
        }
    }
}
