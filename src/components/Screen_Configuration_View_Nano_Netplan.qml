import QtQuick 2.15
import QtQuick.Controls 2.15

Item{
            id: screen_Configuration_View_Nano_Netplan

            Connections{
                target: screen_Configuration_View_Nano

                function onNetplanConfigChanged() {

                    if(screen_Configuration_View_Nano.state !== stateNetplan.name)
                    {
                        return
                    }

                    console.log("INCOMING DC CONFIG ENABLED?: " + screen_Configuration_View_Nano.netplanConfig.enabled)
                    lblDCConfigEnabled.isOn = screen_Configuration_View_Nano.netplanConfig.enabled
                    lblDCConfigAssetAddress.value = screen_Configuration_View_Nano.netplanConfig.assetAddress
                    lblDCConfigNanoAddress.value = screen_Configuration_View_Nano.netplanConfig.nanoAddress
                }
            }

            Column{
                anchors{
                    top: parent.top
                    bottom: parent.bottom
                    horizontalCenter: parent.horizontalCenter
                }

                spacing: 30

                CompToggle{
                    id: lblDCConfigEnabled

                    text: "Direct Connect Enabled: " + Nano.netplanDCConfig.enabled
                    isOn: false
                }

                CompLabelledTextEdit{
                    id: lblDCConfigNanoAddress

                    text: "Direct Connect Nano Address: "
                    value: "---"
                }

                CompLabelledTextEdit{
                    id: lblDCConfigAssetAddress

                    text: "Direct Connect Asset Address: "
                    value: "---"
                }

                Button{
                    id: btnReadConfig

                    text: "Read"

                    onClicked:{
                        Nano.netplan_ReadConfigFile()
                    }
                }

                Button{
                    id: btnWriteConfig

                    text: "Write"

                    onClicked:{

                        var outGoingNetplanConfig = Nano.getNetplanDCConfig()

                        console.log("DC CONFIG ENABLED?: " + lblDCConfigEnabled.isOn)
                        outGoingNetplanConfig.enabled = lblDCConfigEnabled.isOn
                        console.log("DC CONFIG ENABLED 2?: " + outGoingNetplanConfig.enabled)
                        outGoingNetplanConfig.nanoAddress = lblDCConfigNanoAddress.value
                        outGoingNetplanConfig.assetAddress = lblDCConfigAssetAddress.value

                        Nano.netplan_WriteConfig(outGoingNetplanConfig)
                    }
                }
            }

        }
