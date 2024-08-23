import QtQuick 2.0
import QtQuick.Controls 2.15
import SyntaxHighlight_Bash 1.0
import SyntaxHighlight_Py 1.0

Comp__BASE {
    id: compTextEditor

    property string fileName: ""
    property string fileExtension: ""
    property alias textEdit: plainTextViewer
    property alias flickable: flickableMain

    signal textEditTextChanged

    onFileExtensionChanged: {
        if (fileExtension === "")
            return

        plainTextViewer.clearHighlighter()
        plainTextViewer.textFormat = TextEdit.AutoText
        if (fileExtension === "sh") {
            plainTextViewer.width = undefined
            plainTextViewer.wrapMode = TextEdit.NoWrap
            plainTextViewer.font.wordSpacing = 20
            plainTextViewer.highlighter = syntaxHighlight_Bash
            plainTextViewer.highlighter.setTextEditDocument(
                        plainTextViewer.textDocument)
        } else if (fileExtension === "py") {
            plainTextViewer.width = undefined
            plainTextViewer.wrapMode = TextEdit.NoWrap
            plainTextViewer.font.wordSpacing = 20
            plainTextViewer.highlighter = syntaxHighlight_Py
            plainTextViewer.highlighter.setTextEditDocument(
                        plainTextViewer.textDocument)
        } else if (fileExtension === "json") {
            plainTextViewer.width = undefined
            plainTextViewer.font.wordSpacing = 10
            plainTextViewer.wrapMode = TextEdit.NoWrap
        } else if (fileExtension === "md") {
            plainTextViewer.width = flickableMain.width
            plainTextViewer.font.wordSpacing = 10
            plainTextViewer.textFormat = TextEdit.MarkdownText
            plainTextViewer.wrapMode = TextEdit.WordWrap
        } else {
            plainTextViewer.width = flickableMain.width
            plainTextViewer.font.wordSpacing = 10
            plainTextViewer.wrapMode = TextEdit.WordWrap
        }
    }

    SyntaxHighlight_Bash {
        id: syntaxHighlight_Bash
    }

    SyntaxHighlight_Py {
        id: syntaxHighlight_Py
    }

    TextEdit {
        id: emptyTextEdit
        visible: false
    }

    CompLabel {
        id: lblTextViewerTitle

        text: compTextEditor.fileName
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            margins: 20
        }

        color: "white"
    }

    Rectangle {
        id: rectContentsBG

        anchors {
            left: parent.left
            right: parent.right
            top: lblTextViewerTitle.bottom
            bottom: parent.bottom

            margins: 20
        }

        color: "#202020"
    }

    Flickable {
        id: flickableMain

        property int scrollbarWidth: 32

        property alias scrollbar_Vertical: scrollbarVertical
        property alias scrollbar_Horizontal: scrollbarHorizontal

        contentHeight: plainTextViewer.height
        contentWidth: plainTextViewer.width

        clip: true
        boundsBehavior: Flickable.StopAtBounds

        anchors {
            fill: rectContentsBG
            topMargin: 20
            leftMargin: 20
            rightMargin: scrollbarVertical.width + 20
            bottomMargin: scrollbarHorizontal.height + 20
        }

        ScrollBar.vertical: ScrollBar {
            id: scrollbarVertical

            parent: flickableMain.parent
            anchors.top: flickableMain.top
            anchors.left: flickableMain.right
            anchors.leftMargin: 10
            anchors.bottom: flickableMain.bottom
            policy: ScrollBar.AsNeeded

            width: flickableMain.scrollbarWidth
        }

        ScrollBar.horizontal: ScrollBar {
            id: scrollbarHorizontal

            parent: flickableMain.parent
            anchors.left: flickableMain.left
            anchors.top: flickableMain.bottom
            anchors.topMargin: 10
            anchors.right: flickableMain.right
            policy: ScrollBar.AsNeeded

            height: flickableMain.scrollbarWidth
        }

        TextEdit {
            id: plainTextViewer

            property var highlighter: undefined

            readOnly: true
            font.pixelSize: 28
            font.family: "Lato"
            color: "White"

            onTextChanged: compTextEditor.textEditTextChanged()

            function clearHighlighter() {
                if (highlighter === undefined)
                    return

                highlighter.setTextEditDocument(emptyTextEdit.textDocument)
            }
        }
    }
}
