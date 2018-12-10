import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2

InlinePopup {

    property var doneCallback

    closePolicy: Popup.CloseOnEscape
    focus: true
    standardButtons: Dialog.Cancel | Dialog.Ok

    onAccepted: doneCallback(keyInput.text)
    onVisibleChanged: keyInput.clear()

    function getKeyAndThen(cb) {
        doneCallback = cb
        open()
        keyInput.focus = true
    }

    ColumnLayout {
        anchors.fill: parent
        Heading2 {
            text: qsTr("Please enter the management key.")
            color: yubicoBlue
            font.pixelSize: constants.h3
        }

        RowLayout {
            Heading2 {
                text: qsTr("Management key:")
                color: yubicoBlue
                font.pixelSize: constants.h3
            }
            PivManagementKeyTextField {
                id: keyInput
                background.width: width
                Layout.fillWidth: true
                onAccepted: accept()
            }
        }
    }
}
