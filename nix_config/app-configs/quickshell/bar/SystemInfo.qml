pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  id: root

  property string cpuUsage: "0%"
  property string memoryUsage: "0%"
  property string networkInfo: "Disconnected"
  property string networkType: "disconnected"
  property string ethernetIp: ""
  property string wifiIp: ""
  property int batteryLevelRaw: 0
  property string batteryLevel: "0%"
  property string batteryIcon: "󰂎"
  property bool batteryCharging: false
  property bool isLaptop: false
  property string temperature: "0°C"

  Process {
    id: laptopDetectionProc
    command: ["sh", "-c", "chassis=$(cat /sys/class/dmi/id/chassis_type 2>/dev/null); case \"$chassis\" in 8|9|10|11|14|31|32) exit 0 ;; esac; test -e /sys/class/power_supply/BAT*/capacity"]
    running: true

    onExited: (exitCode) => root.isLaptop = exitCode === 0
  }

  // CPU Usage
  Process {
    id: cpuProc
    command: ["sh", "-c", "top -bn1 | grep 'Cpu(s)' | sed 's/.*, *\\([0-9.]*\\)%* id.*/\\1/' | awk '{print $1\"%\"}'"]
    running: true

    stdout: StdioCollector {
      onStreamFinished: {
        root.cpuUsage = text.trim()
      }
    }
  }

  // Memory Usage
  Process {
    id: memProc
    command: ["sh", "-c", "free | grep Mem | awk '{printf \"%.1f%%\", ($3/$2) * 100.0}'"]
    running: true

    stdout: StdioCollector {
      onStreamFinished: {
        root.memoryUsage = text.trim()
      }
    }
  }

  // Network Info (show IPs instead of SSID names)
  Process {
    id: netProc
    command: ["sh", "-c", "wired=$(ip -4 -o addr show up 2>/dev/null | awk '{print $2, $4}' | grep -E '^(en|eth|eno|ens|enp|enx)' | head -1 | awk '{print $2}' | cut -d/ -f1); wifi=$(ip -4 -o addr show up 2>/dev/null | awk '{print $2, $4}' | grep -E '^(wl|wlp|wlan|wifi)' | head -1 | awk '{print $2}' | cut -d/ -f1); if [ -n \"$wired\" ] && [ -n \"$wifi\" ]; then echo \"ethernet:$wired|wifi:$wifi\"; elif [ -n \"$wired\" ]; then echo \"ethernet:$wired\"; elif [ -n \"$wifi\" ]; then echo \"wifi:$wifi\"; else echo 'disconnected:'; fi"]
    running: true

    stdout: StdioCollector {
      onStreamFinished: {
        const result = text.trim()
        root.ethernetIp = ""
        root.wifiIp = ""

        for (const part of result.split("|")) {
          const colonIdx = part.indexOf(':')
          if (colonIdx < 0) continue

          const type = part.substring(0, colonIdx)
          const ip = part.substring(colonIdx + 1)
          if (type === "ethernet") root.ethernetIp = ip
          if (type === "wifi") root.wifiIp = ip
        }

        root.networkType = root.ethernetIp && root.wifiIp ? "both" :
          root.ethernetIp ? "ethernet" : root.wifiIp ? "wifi" : "disconnected"
        root.networkInfo = [root.ethernetIp, root.wifiIp].filter(Boolean).join(" / ") || "Disconnected"
      }
    }
  }

  // Battery
  Process {
    id: batteryProc
    command: ["sh", "-c", "printf '%s\\n%s' \"$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null || echo '99')\" \"$(cat /sys/class/power_supply/BAT*/status 2>/dev/null || echo 'Discharging')\""]
    running: true

    stdout: StdioCollector {
      onStreamFinished: {
        const lines = text.trim().split("\n")
        const level = parseInt(lines[0]) || 0
        const status = (lines[1] || "Discharging").trim()

        root.batteryLevelRaw = level
        root.batteryLevel = level + "%"
        root.batteryCharging = status === "Charging"

        if (root.batteryCharging) root.batteryIcon = ""
        else if (level >= 90) root.batteryIcon = "󰁹"
        else if (level >= 80) root.batteryIcon = "󰂂"
        else if (level >= 70) root.batteryIcon = "󰂁"
        else if (level >= 60) root.batteryIcon = "󰂀"
        else if (level >= 50) root.batteryIcon = "󰁿"
        else if (level >= 40) root.batteryIcon = "󰁾"
        else if (level >= 30) root.batteryIcon = "󰁽"
        else if (level >= 20) root.batteryIcon = "󰁼"
        else if (level >= 10) root.batteryIcon = "󰁻"
        else root.batteryIcon = "󰁺"
      }
    }
  }

  // Temperature
  Process {
    id: tempProc
    command: ["sh", "-c", "sensors 2>/dev/null | grep -E 'Package id 0|Tctl' | head -1 | awk '{print $2}' | sed 's/+//' || echo 'N/A'"]
    running: true

    stdout: StdioCollector {
      onStreamFinished: {
        root.temperature = text.trim() || "N/A"
      }
    }
  }

  // Update timer
  Timer {
    interval: 2000
    running: true
    repeat: true
    onTriggered: {
      cpuProc.running = true
      memProc.running = true
      netProc.running = true
      if (root.isLaptop) batteryProc.running = true
      tempProc.running = true
    }
  }
}