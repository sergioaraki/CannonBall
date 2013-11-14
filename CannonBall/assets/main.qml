import bb.cascades 1.0

NavigationPane {
    id: nav
    Page {
        actions: [
            ActionItem {
                id: play
                title: "Jugar"
                ActionBar.placement: ActionBarPlacement.OnBar
                imageSource: "images/ic_play.png"
                onTriggered: {
                    var page;
                    if (rol.selectedValue ==0){
                        page = flag.createObject();
                    }
                    else {
                        page = cannon.createObject();
                    }
                    nav.push(page);
                }
            }
        ]
        Container {
            layout: DockLayout {
            }
            leftPadding: 20
            rightPadding: 20
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Center
            RadioGroup {
                id: rol
	            options: [
                    Option {
                        description: "Bandera"
                        value: 0
                        selected: true
                    },
	                Option {
                    	description: "Cañon"
                    	value: 1
                    }
	            ]
            }
        }
    }
    attachedObjects: [
        ComponentDefinition {
            id: flag
            source: "flag.qml"
        },
        ComponentDefinition {
            id: cannon
            source: "cannon.qml"
        }
    ]
}

