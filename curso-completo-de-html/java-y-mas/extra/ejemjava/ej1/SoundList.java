/* 
 * Code is the same in both 1.0 and 1.1.
 */

import java.applet.*;
import java.net.URL;

//Loads and holds a bunch of audio files whose locations are specified
//relative to a fixed base URL.
class SoundList extends java.util.Hashtable {
    Applet applet;
    URL baseURL;

    public SoundList(Applet applet, URL baseURL) {
        super(5); //Initialize Hashtable with capacity of 5 entries.
        this.applet = applet;
        this.baseURL = baseURL;
    }

    public void startLoading(String relativeURL) {
        new SoundLoader(applet, this,
                        baseURL, relativeURL);
    }

    public AudioClip getClip(String relativeURL) {
        return (AudioClip)get(relativeURL);
    }

    public void putClip(AudioClip clip, String relativeURL) {
        put(relativeURL, clip);
    }
}
