import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.sailwave 1.0
import "../common"
import "../js/ListExporter.js" as Exporter

Dialog {
    id: dialog
    property string fileFormat: "asemat.xml"
    states: [
        State {
                name: "import"
                PropertyChanges {
                    target: dialogHeader
                    title: qsTr("Import options")
                }
                PropertyChanges {
                    target: pathField
                    text: "https://jollailija.github.io/nettiradio/"
                }
                PropertyChanges {
                    target: vlcMenuItem
                    enabled: false
                }
            },
        State {
                name: "export"
                PropertyChanges {
                    target: dialogHeader
                    title: qsTr("Export options")
                }
                PropertyChanges {
                    target: pathField
                    text: "/home/nemo/"
                }
                PropertyChanges {
                    target: vlcMenuItem
                    enabled: true
                }
            }
    ]

    //acceptDestination: settings.validateStreamUrl ? checkStationPage : null
    canAccept: pathField.text.length > 0 && fileName.text.length > 0;

    onAccepted: {
        switch (state) {
        case "import":
            xmlImporter.startImport(pathField.text+fileName.text, fileFormat)
            break
        case "export":
            Exporter.exportList(stations, pathField.text+fileName.text, fileFormat)
        }
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column
            width: parent.width

            spacing: Theme.paddingMedium

            DialogHeader {
                id: dialogHeader
                acceptText: qsTr("Start")
                title: "error"
            }
            TextField {
                id: fileName
                anchors {
                    left: parent.left
                    right: parent.right
                }

                text: "asemat.xml"
                inputMethodHints: Qt.ImhUrlCharactersOnly
                placeholderText: qsTr("Filename")
                label: placeholderText
            }

            TextField {
                id: pathField
                anchors {
                    left: parent.left
                    right: parent.right
                }

                text: "https://jollailija.github.io/nettiradio/"
                placeholderText: qsTr("File path or remote url")
                label: placeholderText
            }

            ComboBox {
                id: formatCombo
                width: parent.width
                label: qsTrId("Format")
                currentIndex: 0

                menu: ContextMenu {
                    MenuItem {
                        text: "Nettiradio"
                        onClicked: {
                            fileFormat = "asemat.xml"
                            fileName.text = "asemat.xml"
                        }
                    }
                    MenuItem {
                        id: vlcMenuItem
                        text: "VLC/xspf"
                        onClicked: {
                            fileFormat = "vlc"
                            fileName.text = "playlist.xspf"
                        }
                    }
                }
            }

        }
    }
}
