import QtQuick 2.12
import QtQuick.Controls 2.12
import Qt.labs.qmlmodels 1.0
import CONSTANTS 1.0

Item{
    Loader {

        id: loaderAssetInformation
        asynchronous: true
        anchors{
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            leftMargin: 50
            right: parent.right
            rightMargin: 50
            //horizontalCenter: parent.horizontalCenter
        }
        active: currentView === "Asset Information"
        sourceComponent: CompFlippableAssetMetaData {

            id: compFlippableAssetMetaData

            assetType: screenHealthDashboardRoot.assetType


        }

    }

    Loader {

        id: loaderQuickLook
        asynchronous: true
        anchors {
            fill: parent
        }

        active: currentView === "Quick Look"

        sourceComponent: CompQuickView {

            id: compQuickView

            anchors{
                bottom: parent.bottom
                left: parent.left
                leftMargin: 50
                right: parent.right
                rightMargin: 50
                //horizontalCenter: parent.horizontalCenter
            }

        }
    }

    Loader {

        id: loaderComputerVision
        asynchronous: true
        anchors {
            fill: parent
        }

        active: currentView === "Computer Vision"

        sourceComponent: Item {
            id: compHealthDashboardViewComputerVision
            Rectangle {
                anchors {
                    fill: parent
                }
                color: "#3C3F65"
            }

        }

    }

    Loader {

        id: loadderLiveData

        asynchronous: true

        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        active: currentView === "Live Data"

        sourceComponent: CompHealthDashboardContent {
            id: comHealthDashboardContentOmega

            //onToggleViewModeClicked: screenHealthDashboardRoot.toggleViewMaximized()
            anchors{
                bottom: parent.bottom
                left: parent.left
                leftMargin: 50
                right: parent.right
                rightMargin: 50
                //horizontalCenter: parent.horizontalCenter
            }

            onParamNameSelectedChanged: {
                //console.log('Paramname changed relay A')
                screenHealthDashboardRoot.parameterNameSelected = comHealthDashboardContentOmega.paramNameSelected
            }


        }


    }

}
