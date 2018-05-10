(
	SynthDef(\record, { arg out=0,bufnum=0;
		var formant;
		// XLine will free the Synth when done
		formant = Formant.ar(XLine.kr(400,1000, 4, doneAction: 2), 2000, 800, 0.125);
		RecordBuf.ar(formant, bufnum);
	}).add;
)

