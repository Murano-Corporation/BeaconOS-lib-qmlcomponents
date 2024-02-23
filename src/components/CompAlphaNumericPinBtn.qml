import QtQuick 2.12
import QtQuick.Controls 2.12

CompNumpadBtn {
    id: compAlphaNumPinBtnRoot

    property var listOfOptions: ['2','A','B','C']
    property int optionsIndex: 0
    property bool updatingIndexInternal: false
    property int numPinEntry: 0
    property int maxPinLength: 5
    property CompNumpadBtn currentPinBtn: CompNumpadBtn{ text: "Text"}


    signal alphaNumPinClicked(string txt)

    onCurrentPinBtnChanged: {
        //console.log("Resetting pin button options index for: " + compAlphaNumPinBtnRoot.text)
        compAlphaNumPinBtnRoot.optionsIndex = 0
    }

    onOptionsIndexChanged: {
        //console.log("Options index changed for " + compAlphaNumPinBtnRoot.text + " to " + optionsIndex)

        if(!updatingIndexInternal &&  optionsIndex >= listOfOptions.length)
        {
            //console.log("Resetting " + compAlphaNumPinBtnRoot.text + " option index to 0")
            updatingIndexInternal = true
            optionsIndex = 0
            updatingIndexInternal = false
        }
    }

    onClicked: txt => {
                   if (numPinEntry === maxPinLength)
                   {
                       return
                   }
                   var textOut = compAlphaNumPinBtnRoot.listOfOptions[compAlphaNumPinBtnRoot.optionsIndex]
                   compAlphaNumPinBtnRoot.alphaNumPinClicked(textOut)
                   compAlphaNumPinBtnRoot.optionsIndex += 1

               }

    text: listOfOptions[0]

    Row{
        anchors{
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }
        spacing: 4
        Repeater{
            model: compAlphaNumPinBtnRoot.listOfOptions.length - 1

            CompLabel{
                text: compAlphaNumPinBtnRoot.listOfOptions[index + 1]
                bottomPadding: 20
                font{
                    pixelSize: 12
                }
            }
        }
    }


}
