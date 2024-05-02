import QtQuick 2.12

Item{
    id: compHealthContextNavBtnOmega

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

//    Connections{
//        target: SeverityHandler

//        onSignal_AlertCountsChanged: function(sPath, iCount)
//        {
//            if(sPath !== myHierarchyPath)
//            {
//                return
//            }

//            console.log("My alert count changed to " + iCount)
//            alertCounts = iCount

//        }
//    }

    CompGlassRect{
        anchors.fill: parent
    }




    Item{
        id: contentsGroup

        width: Math.min(Math.max(btnIcon.width, btnLbl.width), parent.width)
        height: 100
        anchors{
            //centerIn: parent
            fill: parent
        }

        CompImageIcon {
            id: btnIcon

            anchors{
               //horizontalCenter: parent.horizontalCenter
                left: parent.left
                leftMargin: 20
                verticalCenter: parent.verticalCenter
            }

            height: ((compHealthContextNavBtnOmega.iconUrl === "") ? 0 : 124)

            width: ((compHealthContextNavBtnOmega.iconUrl === "") ? 0 : 124)
            source: compHealthContextNavBtnOmega.iconUrl
            color: "#9287ED"
        }

        CompLabel{
            id: btnLbl
            text: compHealthContextNavBtnOmega.text

            width: Math.min(btnLbl.implicitWidth, compHealthContextNavBtnOmega.width)
            //horizontalAlignment: "AlignHCenter"
            verticalAlignment: "AlignVCenter"

            wrapMode: Text.WordWrap
            anchors{
                verticalCenter: btnIcon.verticalCenter
//                top: compHealthContextNavBtnOmega.iconUrl === "" ? undefined : btnIcon.bottom
//                topMargin: (compHealthContextNavBtnOmega.iconUrl === "" ? 0 : 28)
                left: compHealthContextNavBtnOmega.iconUrl === "" ? parent.left : btnIcon.right
                leftMargin: (compHealthContextNavBtnOmega.iconUrl === "" ? 40 : 28)
                //centerIn: (compHealthContextNavBtnOmega.iconUrl === "" ? parent : undefined)
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
        alertCount: compHealthContextNavBtnOmega.alertCounts

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
    D{i:0;autoSize:true;formeditorZoom:0.25;height:1920;width:1080}
}
##^##*/
