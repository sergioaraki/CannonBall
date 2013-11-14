import bb.cascades 1.0
import my.library 1.0
import bb.multimedia 1.0

Page {
    actionBarVisibility: ChromeVisibility.Hidden
    function actualizaDistancia(dist){
        distancia.text = "Distancia: "+dist+" m";
    }
    Container {
        layout: StackLayout {
        }
        topPadding: 20
        leftPadding: 20
        rightPadding: 20
        Label {
            id: distancia
            textStyle.base: SystemDefaults.TextStyles.BigText
            horizontalAlignment: HorizontalAlignment.Center
        }
        Container {
            layout: DockLayout {
            }
            horizontalAlignment: HorizontalAlignment.Center
            ImageView {
                imageSource: "images/flag.png"
                animations: [
                    RotateTransition {
                        id: bajar
                        toAngleZ: 180
                        duration: 1000
                    },
                    RotateTransition {
                        id: subir
                        toAngleZ: 0
                        duration: 1000
                    }
                ]
                maxHeight: 475
            }
            ImageView {
                id: exp
                imageSource: "images/exp.png"
                visible: false
                animations: [
                    SequentialAnimation {
                        id: animExp
                        animations: [
                            ScaleTransition {
                                toX: 0.5
                                toY: 0.5
                                duration: 250
                            },
                            ScaleTransition {
                                toX: 1.0
                                toY: 1.0
                                duration: 250
                            },
                            ScaleTransition {
                                toX: 0.5
                                toY: 0.5
                                duration: 250
                            },
                            ScaleTransition {
                                toX: 1.0
                                toY: 1.0
                                duration: 250
                            }
                        ]
                        onStarted: {
                            exp.visible = true;
                        }
                        onEnded: {
                            exp.visible = false;
                        }
                    }
                ]
            }
        }
        WebView {
            url: "local:///assets/webview/flag.html"
            id: server
            onMessageReceived: {
                if (message.data.match('dist')) {
                    var dist = message.data.split('-')[1];
                    actualizaDistancia(dist);
                }
                else if (message.data == 'Bandera') {
                    bajar.play();
                    pause.start();
                    animExp.play();
                    sound.play();
                }
            }
            settings.background: Color.Transparent 
            maxWidth: 680
        }
    }
    attachedObjects: [
        QTimer{
            id: pause
            interval: 5000
            onTimeout:{
                subir.play();
                pause.stop();
            }
        },
        MediaPlayer {
            id: sound
            sourceUrl: "sounds/down.wav"
        }   
    ]
    onCreationCompleted: {
        Application.mainWindow.screenIdleMode = 1;
    }
}
