import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2

InlinePopup {

    property alias lockCode: lockCodeInput.text

    closePolicy: Popup.NoAutoClose
    onVisibleChanged: lockCodeInput.clear()

    ColumnLayout {
        anchors.fill: parent
        Heading2 {
            text: qsTr("Configuration is protected by a lock code")
            color: yubicoBlue
            font.pixelSize: constants.h3
        }

        RowLayout {
            Heading2 {
                text: qsTr("Lock Code")
                color: yubicoBlue
                font.pixelSize: constants.h3
            }
            TextField {
                id: lockCodeInput
                validator: RegExpValidator {
                    regExp: /[0-9a-fA-F]{32}$/
                }
                Layout.fillWidth: true
                background.width: width
                echoMode: TextInput.Password
                ToolTip.delay: 1000
                ToolTip.visible: hovered
                ToolTip.text: qsTr("Lock code must be a 32 characters (16 bytes) hex value")
                selectByMouse: true
                selectionColor: yubicoGreen
            }
        }
    }
    standardButtons: Dialog.Cancel | Dialog.Ok
}
