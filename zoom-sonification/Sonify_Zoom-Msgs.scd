/********************************************************************\
*                                                                   *
*       A creative use of chat messages from Zoom sessions:         *
*        A spontaneous generative composition that sonifies         *
* the messages from a Zoom session of the Audio Programming Class.  *
* The custom made system reads the stored Zoom chat file            *
* turning participant discussions to endless sonic manifestations.  *
*            ***************************                            *
*            * Istanbul, - 7/April/2020 *                           *
*             *********     **********                              *
********************************************************************/

/*(
o = Server.default.options;
//o.device = "BlackHole 16ch";
s.reboot
)*/

(
w = Window("SonZoomMsgs", Rect(100,Window.screenBounds.height-180,300,100));w.front;
a = StaticText(w, Rect(10, 10, 1320, 100));
a.background=Color.grey;
a.align = \center;
a.font = Font("Monaco", 36);

~zoomFile = FileReader.read("/path/to/file.txt", true, true, delimiter: $:).postcs
);

(
~getMsg = {| msg |
	var message = ~zoomFile[msg];
	message
};

~msg = {| string |
	var name, msg, array;
	name = ~getMsg.value(string)[2];
	name = name.drop(2);
	msg = ~getMsg.value(string)[3];

	array = [];
	array = [name, msg];
	~array = array;
	//[name, msg].postln
};
);

(
var dur = 5;
Tdef(\x, {

	loop{
		dur.wait;
		{
			~sonif.value(rrand(0, ~zoomFile.size - 1) );
			a.string = ~array.asString
		}.defer;
	}.fork
}).play;

~sonif = {| msg |
	~msg.value(msg);

	a = Pbindef(\x,
		//\instrument, \default, //assign to any SynthDef
		\dur, dur/2,
		\octave, 1,
		\degree, Pseq(~array[1].ascii.cpsmidi.round(0.1), 1),
		\scale, Scale.phrygian,
		\attack, 3,
		\decay, 0.3,
		\sustain, 3,
		\release, 0.1,
		\filterSpeed, 0.1,
		\filterFreqStart, 2000,
		\filterFreqEnd, 3000,
		\resonance, 0.3,
		\hfFilterFreq, 5,
		\amp, 0.1
	).trace.play;

}
)