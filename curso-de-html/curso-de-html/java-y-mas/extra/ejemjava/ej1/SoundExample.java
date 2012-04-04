/*
 * 1.0 code.
 */

import java.applet.*;
import java.awt.*;

public class SoundExample extends Applet {
    SoundList soundList;
    String onceFile = "bark.au";
    String loopFile = "train.au";
    AudioClip onceClip;
    AudioClip loopClip;

    Button playOnce;
    Button startLoop;
    Button stopLoop;
    Button reload;

    boolean looping = false;

    public void init() {
        playOnce = new Button("Bark!");
        add(playOnce);

        startLoop = new Button("Start sound loop");
        stopLoop = new Button("Stop sound loop");
        stopLoop.disable();
        add(startLoop);
        add(stopLoop);

        reload = new Button("Reload sounds");
        add(reload);

        validate();

        startLoadingSounds();
    }

    void startLoadingSounds() {
        //Start asynchronous sound loading.
        soundList = new SoundList(this, getCodeBase());
        soundList.startLoading(loopFile);
        soundList.startLoading(onceFile);
   }

    public void stop() {
        //If one-time sound were long, we'd stop it here, too.
        if (looping) {
            loopClip.stop();    //Stop the sound loop.
        }
    }    

    public void start() {
        if (looping) {
            loopClip.loop();    //Restart the sound loop.
        }
    }    

    public boolean action(Event event, Object arg) {
        //PLAY BUTTON
        if (event.target == playOnce) {
            if (onceClip == null) {
                //Try to get the AudioClip.
                onceClip = soundList.getClip(onceFile);
            }

            if (onceClip != null) {  //If the sound is loaded:
                onceClip.play();     //Play it once.
                showStatus("Playing sound " + onceFile + ".");
            } else {
                showStatus("Sound " + onceFile + " not loaded yet.");
            }
            return true;
        }

        //START LOOP BUTTON
        if (event.target == startLoop) {
            if (loopClip == null) {
                //Try to get the AudioClip.
                loopClip = soundList.getClip(loopFile);
            }

            if (loopClip != null) {  //If the sound is loaded:
                looping = true;
                loopClip.loop();     //Start the sound loop.
                stopLoop.enable();   //Enable stop button.
                startLoop.disable(); //Disable start button.
                showStatus("Playing sound " + loopFile + " continuously.");
            } else {
                showStatus("Sound " + loopFile + " not loaded yet.");
            }
            return true;
        }

        //STOP LOOP BUTTON
        if (event.target == stopLoop) {
            if (looping) {
                looping = false;
                loopClip.stop();    //Stop the sound loop.
                startLoop.enable(); //Enable start button.
                stopLoop.disable(); //Disable stop button.
            }
            showStatus("Stopped playing sound " + loopFile + ".");
            return true;
        }

        //RELOAD BUTTON
        if (event.target == reload) {
            if (looping) {          //Stop the sound loop.
                looping = false;
                loopClip.stop();
                startLoop.enable(); //Enable start button.
                stopLoop.disable(); //Disable stop button.
            }
            loopClip = null;        //Reset AudioClip to null.
            onceClip = null;        //Reset AudioClip to null.
            startLoadingSounds();
            showStatus("Reloading all sounds.");
            return true;
        }

        return false; //some event I don't know about...
    }
}
