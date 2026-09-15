import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ShellRoot {

    // Waybar-style workspace icons
    property var workspaceIcons: [
        "󰎤",
        "󰎧",
        "󰎪",
        "󰎭",
        "󰎱",
        "󰎳",
        "󰎶",
        "󰎹",
        "󰎼",
        "󰽽"
    ]

    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData

            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 32

            color: "#1e1e2e"

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10

                spacing: 8

                // ─────────────────────────────
                // Workspaces
                // ─────────────────────────────

                Row {
                    spacing: 4

                    Repeater {
                        model: 10

                        delegate: Rectangle {
                            required property int index

                            width: 28
                            height: 24

                            radius: 5

                            color: "#313244"

                            Text {
                                anchors.centerIn: parent

                                text: workspaceIcons[index]

                                color: "white"
                                font.pixelSize: 18
                            }

                            MouseArea {
                                anchors.fill: parent

                                onClicked: {
                                    Quickshell.execDetached([
                                        "hyprctl",
                                        "dispatch",
                                        "workspace",
                                        String(index + 1)
                                    ])
                                }
                            }
                        }
                    }
                }

                // Push everything after workspaces toward center/right
                Item {
                    Layout.fillWidth: true
                }

                // ─────────────────────────────
                // Window title
                // ─────────────────────────────

                Text {
                    text: "Quickshell"

                    color: "white"

                    elide: Text.ElideRight

                    Layout.maximumWidth: 400
                }

                // Push right-side modules to the right
                Item {
                    Layout.fillWidth: true
                }

                // ─────────────────────────────
                // Volume
                // ─────────────────────────────

                Text {
                    text: "󰕾"

                    color: "white"

                    font.pixelSize: 16
                }

                Text {
                    text: "Volume"

                    color: "white"
                }

                // ─────────────────────────────
                // Network
                // ─────────────────────────────

                Text {
                    text: "󰤨"

                    color: "white"

                    font.pixelSize: 16
                }

                // ─────────────────────────────
                // Clock
                // ─────────────────────────────

                Text {
                    text: Qt.formatDateTime(
                        new Date(),
                        "ddd, dd. MMM  HH:mm"
                    )

                    color: "white"
                }
            }
        }
    }
}