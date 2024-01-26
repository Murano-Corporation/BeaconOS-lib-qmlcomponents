import QtQuick 2.12
import QtQuick.Controls 2.12

Rectangle{
    id: compExpandableBtnBreadcrumbRoot

    property alias labelMain: lbl
    property int myIndex: index
    property var myModelData: model
    property alias titleIconSource: icon.source
    property alias titleText: lbl.text
    property bool isExpanded: false
    property bool expandable: true
    property bool showQuickActions: true
    property real maxExpandableHeight: 400
    property real minimumHeight: 60
    property string contents: ""

    onContentsChanged: {
        contents_formatted = htmlFormatter.htmlTextDecorators_Pre + contents + htmlFormatter.htmlTextDecorators_Post
    }
    property string contents_formatted

    //onContents_formattedChanged: {
    //    console.log("Contents Formatted now: " + contents_formatted)
    //}

    property var listQuickActions


    width: parent.width
    height: compExpandableBtnBreadcrumbRoot.minimumHeight



    signal chatWithAiClicked(int index)

    signal clicked()
    //state: "expanded"

    function getMinimumHeight(){
        var retVal = 0;

        if(!isExpanded)
            return compExpandableBtnBreadcrumbRoot.minimumHeight

        retVal += lbl.anchors.topMargin
        retVal += lbl.height
        retVal += rectSep.anchors.topMargin
        retVal += rectSep.height
        retVal += scrollView.anchors.topMargin
        retVal += scrollView.implicitContentHeight
        retVal += textHTML.implicitHeight
        retVal += scrollView.anchors.bottomMargin

        if(showQuickActions)
        {

            retVal += listQuickActions.height
            retVal += listQuickActions.anchors.bottomMargin
        }

        return retVal
    }

    function onQuickActionClicked(quickActionText)
    {
        if(quickActionText === "openAIChat")
        {
            compExpandableBtnBreadcrumbRoot.chatWithAiClicked(myModelData)
            return;
        }

        console.log("Unahandled quickActionText '" + quickActionText + "'")
    }

    Util_HtmlFormatter{
        id: htmlFormatter
    }


    onClicked: {
        isExpanded = !isExpanded
    }

    states: [
        State {
            name: "default"
            when: !compExpandableBtnBreadcrumbRoot.isExpanded

            PropertyChanges{
                target: compExpandableBtnBreadcrumbRoot

                height: compExpandableBtnBreadcrumbRoot.minimumHeight
            }

            PropertyChanges {
                target: rectExpandedBg
                visible: false

            }

            PropertyChanges {
                target: rectShrunkenBg
                visible: true

            }

            PropertyChanges{
                target: iconArrowExpanded
                source: "file:///usr/share/BeaconOS-lib-images/images/RightFill.svg"
            }

            PropertyChanges{
                target: scrollView
                visible: false
            }

            PropertyChanges{
                target: listQuickActions
                visible: false
            }

            PropertyChanges {
                target: btnQuickActionBack
                visible: false

            }

        },
        State {
            name: "expanded"
            when: compExpandableBtnBreadcrumbRoot.isExpanded

            PropertyChanges{
                target: compExpandableBtnBreadcrumbRoot

                height: Math.min(compExpandableBtnBreadcrumbRoot.maxExpandableHeight, compExpandableBtnBreadcrumbRoot.getMinimumHeight())
            }

            PropertyChanges {
                target: rectExpandedBg
                visible: true

            }

            PropertyChanges {
                target: rectShrunkenBg
                visible: false

            }

            PropertyChanges{
                target: iconArrowExpanded
                image.source: "file:///usr/share/BeaconOS-lib-images/images/DownFill.svg"
            }

            PropertyChanges{
                target: scrollView
                visible: true
            }

            PropertyChanges {
                target: textHTML
                text: compExpandableBtnBreadcrumbRoot.contents_formatted
            }

            PropertyChanges{
                target: listQuickActions
                visible: compExpandableBtnBreadcrumbRoot.showQuickActions
            }

            PropertyChanges {
                target: btnQuickActionBack
                visible: compExpandableBtnBreadcrumbRoot.showQuickActions

            }
        }
    ]

    color: "transparent"
    state: "default"

    CompBtnBreadcrumb{
        id: rectShrunkenBg
        anchors.fill: parent
    }


    CompGlassRect{
        id: rectExpandedBg
        anchors.fill: parent
    }

    CompImageIcon{
        id: icon

        image.source: "file:///usr/share/BeaconOS-lib-images/images/Help.svg"

        anchors{
            left: parent.left
            leftMargin: 20
            verticalCenter: lbl.verticalCenter
        }

        height: lbl.height
        width: height
    }

    CompLabel{
        id: lbl
        text: '[Notification Text]'
        anchors{
            top: parent.top
            left: icon.right
            leftMargin: 10
            topMargin: (compExpandableBtnBreadcrumbRoot.minimumHeight - lbl.height) * 0.5
            right: iconArrowExpanded.left
            rightMargin: 10
        }
        font{
            pixelSize: 20
            weight: Font.Light
        }

        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    CompImageIcon{
        id: iconArrowExpanded

        visible: compExpandableBtnBreadcrumbRoot.expandable

        source: "file:///usr/share/BeaconOS-lib-images/images/DownFill.svg"
        color: "#80ffffff"
        anchors{
            right: parent.right
            rightMargin: 20
            verticalCenter: lbl.verticalCenter
        }

        height: lbl.height
        width: height
    }

    Rectangle{
        id: rectSep

        visible: compExpandableBtnBreadcrumbRoot.state === 'expanded'

        anchors{
            left: icon.left
            right: iconArrowExpanded.right
            top: lbl.bottom
            topMargin: 10
        }

        height: 2
        radius: 0.5 * height
        color: "#33ffffff"
    }

    ScrollView{
        id: scrollView

        anchors{
            top: rectSep.bottom
            topMargin: 20
            left: rectSep.left
            right: rectSep.right
            bottom: compExpandableBtnBreadcrumbRoot.showQuickActions ?  listQuickActions.top : parent.bottom
            bottomMargin: 10
        }

        TextArea{
            id: textHTML
            readOnly: true
            implicitWidth: scrollView.width

            textFormat: "RichText"
            wrapMode: "WordWrap"
            text: compExpandableBtnBreadcrumbRoot.contents_formatted
            focus: true
            onLinkActivated: {
                var l = link
                var p = compExpandableBtnBreadcrumbRoot.myModelData.Parameters
                var m = compExpandableBtnBreadcrumbRoot.myModelData

                HtmlHandler.slot_OnLinkActivated(link, compExpandableBtnBreadcrumbRoot.myModelData.Parameters)
            }


        }

    }


    CompBtnBreadcrumb{
        id: btnQuickActionBack
        clip: false
        visible: compExpandableBtnBreadcrumbRoot.showQuickActions
        consoleOutputsEnabled: true
        anchors{
            left: rectSep.left
            bottom: parent.bottom
            bottomMargin: 20
        }

        text: ""

        iconSource: "file:///usr/share/BeaconOS-lib-images/images/LeftFill.svg"
        iconColor: "#FFFFFF"
        iconHeight: 30
        iconWidth: 30


        onClicked: compExpandableBtnBreadcrumbRoot.clicked()
    }

    ListView{
        id: listQuickActions
        clip: true
        visible: compExpandableBtnBreadcrumbRoot.showQuickActions
        anchors{
            left: btnQuickActionBack.right
            leftMargin: 14
            right: rectSep.right
            bottom: parent.bottom
            bottomMargin: 20
            top: btnQuickActionBack.top
        }


        orientation: ListView.Horizontal
        boundsBehavior: Flickable.StopAtBounds

        model: compExpandableBtnBreadcrumbRoot.listQuickActions
        spacing: 14
        delegate: CompBtnBreadcrumb{

            property var myModelData: modelData

            iconSource: ''
            iconColor: "#9287ed"
            iconWidth: 19
            iconHeight: 19
            text: myModelData.text


            font.pixelSize: 22
            font.weight: Font.Light


            onClicked: {
                console.log("Breadcrumb button clicked")
                Notifications.slot_OnNotificationQuickActionClicked(index, compExpandableBtnBreadcrumbRoot.myModelData.map_data)
            }
        }

    }

    MouseArea{
        id: mousearea

        anchors{
            left:parent.left
            top:parent.top
            right: parent.right
            bottom: lbl.bottom
        }

        onClicked: compExpandableBtnBreadcrumbRoot.clicked()
    }


}

/*##^##
Designer {
    D{i:0;formeditorColor:"#000000";formeditorZoom:0.9;height:600}
}
##^##*/
