import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: root

    property bool primaryScreen: Screen.name === "DP-1"

    Image {
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        source: "w3.jpg"
    }

    Rectangle {
        anchors.fill: parent
        color: "#99000000"
    }

    ColumnLayout {
        visible: root.primaryScreen
        anchors.centerIn: parent
        width: Math.min(parent.width * 0.8, 360)
        spacing: 12

        TextField {
            id: username
            Layout.fillWidth: true
            placeholderText: "Username"
            inputMethodHints: Qt.ImhNoAutoUppercase
            focus: true
            onAccepted: password.forceActiveFocus()
        }

        TextField {
            id: password
            Layout.fillWidth: true
            placeholderText: "Password"
            echoMode: TextInput.Password
            onAccepted: login()
        }

        Button {
            Layout.fillWidth: true
            text: "Log in"
            onClicked: login()
        }
    }

    function login() {
        if (username.text.length > 0) {
            sddm.login(username.text, password.text, sessionModel.lastIndex)
        }
    }

    Connections {
        target: sddm

        function onLoginFailed() {
            password.clear()
            password.forceActiveFocus()
        }
    }
}