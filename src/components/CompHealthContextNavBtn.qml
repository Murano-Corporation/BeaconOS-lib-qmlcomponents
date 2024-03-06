import QtQuick 2.12

Comp__BASE {
    id: compHealthContextNavBtn

    property string text: "%TEXT%"
    property string myHierarchyPath: text

    property string iconUrl: ""
    property alias fontPixelSize: btnLbl.font.pixelSize
    property int alertCounts: 0
    signal clicked(string text)


    onMyHierarchyPathChanged: {

        if(myHierarchyPath.includes("null."))
        {
            return
        }

        //console.log(text + " requesting alert counts for " + myHierarchyPath)
        alertCounts = SeverityHandler.getAlertCountsFor(myHierarchyPath)
    }

    Component.onCompleted: {

        if(myHierarchyPath.includes("null."))
        {
            return
        }

        //console.log(text + " requesting alert counts for " + myHierarchyPath)
        alertCounts = SeverityHandler.getAlertCountsFor(myHierarchyPath)
    }

    Connections{
        target: SeverityHandler

        function onSignal_AlertCountsChanged(sPath, iCount)
        {
            if(sPath !== myHierarchyPath)
            {
                return
            }

            console.log("My alert count changed to " + iCount)
            alertCounts = iCount

        }
    }

    CompGlassRect{
        anchors.fill: parent
    }




    Item{
        id: contentsGroup

        width: parent.width
        height: btnLbl.y + btnLbl.height
        anchors{
            centerIn: parent
        }


        CompImageIcon {
            id: btnIcon

            anchors{
               horizontalCenter: parent.horizontalCenter
            }

            height: ((compHealthContextNavBtn.iconUrl === "") ? 0 : 124)

            width: ((compHealthContextNavBtn.iconUrl === "") ? 0 : 124)
            source: compHealthContextNavBtn.iconUrl
            color: "#9287ED"
        }

        CompLabel{
            id: btnLbl
            text: compHealthContextNavBtn.text

            //width: Math.min(btnLbl.implicitWidth, compHealthContextNavBtn.width)
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            anchors{
                left: parent.left
                leftMargin: 20
                right: parent.right
                rightMargin: 20
                top: compHealthContextNavBtn.iconUrl === "" ? undefined : btnIcon.bottom
                topMargin: (compHealthContextNavBtn.iconUrl === "" ? 0 : 28)
                //centerIn: (compHealthContextNavBtn.iconUrl === "" ? parent : undefined)
            }

            font{
                pixelSize: 34
            }
        }

    }

    CompIndicatorAlertCount {
        id: alertIndicator
        alertCount: compHealthContextNavBtn.alertCounts

        anchors{
            top: parent.top
            topMargin: 20
            right: parent.right
            rightMargin: 20
        }
    }


    MouseArea{
        anchors{
            fill: parent
        }

        onClicked: parent.clicked( parent.text )

    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
