import QtQuick 2.12

Comp__BASE {
    id: compHealthContextNavBtn

    property string text: "%TEXT%"
    property string myHierarchyPath: text

    property string iconUrl: ""
    property alias fontPixelSize: btnLbl.font.pixelSize
    property alias rightBtnArrow: btnRightArrow
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
        visible: isDelta

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

    Item{
        id: contentsGroupOmega
        visible: !isDelta

        width: Math.min(Math.max(btnIcon.width, btnLbl.width), parent.width)
        height: 100
        anchors{
            //centerIn: parent
            fill: parent
        }

        CompImageIcon {
            id: btnIconOmega

            anchors{
               //horizontalCenter: parent.horizontalCenter
                left: parent.left
                leftMargin: 20
                verticalCenter: parent.verticalCenter
            }

            height: ((compHealthContextNavBtn.iconUrl === "") ? 0 : 124)

            width: ((compHealthContextNavBtn.iconUrl === "") ? 0 : 124)
            source: compHealthContextNavBtn.iconUrl
            color: "#9287ED"
        }

        CompLabel{
            id: btnLblOmega
            text: compHealthContextNavBtn.text

            width: Math.min(btnLblOmega.implicitWidth, compHealthContextNavBtn.width)
            //horizontalAlignment: "AlignHCenter"
            verticalAlignment: "AlignVCenter"

            wrapMode: Text.WordWrap
            anchors{
                verticalCenter: btnIconOmega.verticalCenter
//                top: compHealthContextNavBtn.iconUrl === "" ? undefined : btnIcon.bottom
//                topMargin: (compHealthContextNavBtn.iconUrl === "" ? 0 : 28)
                left: compHealthContextNavBtn.iconUrl === "" ? parent.left : btnIconOmega.right
                leftMargin: (compHealthContextNavBtn.iconUrl === "" ? 40 : 28)
                //centerIn: (compHealthContextNavBtn.iconUrl === "" ? parent : undefined)
            }

            font{
                pixelSize: 34
            }
        }

        CompIconBtn{
            id: btnRightArrow

            //visible: false

            height: 55
            iconUrl: "file:///usr/share/BeaconOS-lib-images/images/RightFill.svg"

            iconColor: "#ffffff"

            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 20

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
