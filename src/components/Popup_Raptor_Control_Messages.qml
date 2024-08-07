import QtQuick 2.15

Comp__BASE_Popup{
        id: popupRaptorControlMessages

        height: 600
        width: 400

        compBaseRadius: 20


        modal: true

        CompPopupBG {
            id: bg
            anchors.fill: parent

            CompLabel{
                id: lblPrearmChecks

                anchors{
                    top: parent.top
                    left: parent.left
                    right: parent.right
                    margins: 20
                }

                text: "Messages"
            }

            ListView {
                id: listPrearmChecks

                property int lblWidth_Severity: 64
                property int lblWidth_Text: 600
                property int lblSpacing: 40
                property int itemHeight: 64
                property int itemWidth: lblWidth_Severity + lblSpacing + lblWidth_Text

                boundsBehavior: Flickable.StopAtBounds

                onCountChanged: {
                    listPrearmChecks.currentIndex = (listPrearmChecks.count - 1)
                }

                clip: true
                model: TableModelDroneMessages
                anchors{
                    top: lblPrearmChecks.bottom
                    left: lblPrearmChecks.left
                    right: lblPrearmChecks.right
                    bottom: parent.bottom
                    bottomMargin: 20
                }

                delegate: Item {
                    id: compRaptorControlMessageDelegate
                    opacity: index === listPrearmChecks.currentIndex ? 1.0 : 0.3
                    property int severity: model.severity
                    property string text: model.text

                    height: listPrearmChecks.itemHeight
                    width: listPrearmChecks.itemWidth

                    CompLabel {
                        id: lblSeverity

                        width: listPrearmChecks.lblWidth_Severity
                        text: parent.severity
                        verticalAlignment: Text.AlignVCenter

                        anchors{
                            top: parent.top
                            left: parent.left
                            bottom: parent.bottom
                        }
                    }

                    CompLabel {
                        id: lblText

                        width: listPrearmChecks.lblWidth_Text
                        text: parent.text
                        verticalAlignment: Text.AlignVCenter

                        anchors{
                            top: parent.top
                            left: lblSeverity.right
                            leftMargin: listPrearmChecks.lblSpacing
                            bottom: parent.bottom
                        }
                    }


                }
            }
        }


    }
