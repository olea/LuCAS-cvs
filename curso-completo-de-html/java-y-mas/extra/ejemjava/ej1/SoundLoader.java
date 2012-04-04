/* 
 * Code is the same in both 1.0 and 1.1.
 */

import java.applet.*;
import java.net.URL;

class SoundLoader extends Thread {
    Applet applet;
    SoundList soundList;
    URL baseURL;
    String relativeURL;

    public SoundLoader(Applet applet, SoundList soundList,
                       URL baseURL, String relativeURL) {
        this.applet = applet;
        this.soundList = soundList;
        this.baseURL = baseURL;
        this.relativeURL = relativeURL;
        setPriority(MIN_PRIORITY);
        start();
    }

    public void run() {
        AudioClip audioClip = applet.getAudioClip(baseURL, relativeURL);

        //AudioClips load too fast for me!
        //Simulate slow loading by adding a delay of up to 10 seconds.
        try {
            sleep((int)(Math.random()*10000));
        } catch (InterruptedException e) {}

        soundList.putClip(audioClip, relativeURL);
    }
}
