s.quit;

// **********************************************************************
// 1. SERVER CONFIG - any server setup key to this piece
// **********************************************************************

// read ServerOptions help file for properties of s.options
s = Server.local;
s.options.outDevice_('Built-in Output');
s.options.numOutputBusChannels_(4);
s.options.inDevice_('Built-in Microph');
s.options.numInputBusChannels_(2);
s.options.sampleRate_(44100);
s.options.memSize_(2.pow(20)); // roughly 1 gig of realtime memory
s.newBusAllocators;
ServerBoot.removeAll;
ServerTree.removeAll;
ServerQuit.removeAll;

// **********************************************************************
// 2. INIT GLOBAL VARIABLES
// **********************************************************************
~out = 0;
~in1 = 4; 
~in2 = 5; 
TempoClock.default.tempo = 104 / 60;
~projectPath = "/Users/Pete/Documents/my-coding/supercollider/projects/project_loopers";
~synthsPath = ~projectPath++"/synths";

// **********************************************************************
// 3. DEFINE PIECE SPECIFIC FUNCTIONS
// **********************************************************************
~makeBuffers = {
	~loop1 = Buffer.alloc(s, 44100 * 10, 1); // a four second 1 channel Buffer
	~input1 = Buffer.alloc(s, 44100 * 4.0, 1); // a four second 1 channel Buffer

};

~makeBusses = {
	~busses = Dictionary.new;
	~busses.add(\reverb -> Bus.audio(s, 2));
	// add more busses as you need them
};

~cleanup = {
	s.newBusAllocators;
	ServerBoot.removeAll;
	ServerTree.removeAll;
	ServerQuit.removeAll;
};

~makeNodes = {
	~mainGroup = Group.new;
	~reverbGroup = Group.after(~mainGroup);
	// define more fx nodes as you need them
};

// **********************************************************************
// 4. REGISTER FUNCTIONS WITH ABSTRACT SERVER ACTION
// **********************************************************************
ServerBoot.add(~makeBuffers); // make ~buffers
ServerBoot.add(~makeBusses); // make ~busses
ServerQuit.add(~cleanup); // clean up when quit the server

// **********************************************************************
// 5. BOOT SERVER
// **********************************************************************
s.waitForBoot({
	s.sync; // ensure actions have completed before moving on (synchronous)
	// 5a. REGISTER SYNTHDEFS
	(~synthsPath++"/record.scd").load;
	(~synthsPath++"/play.scd").load;
	s.sync;
	// load state
	(~projectPath++"/data.scd").load;
	// 5b. CREATE NODES AND EVENTS
	ServerTree.add(~makeNodes); // delay these until you've created your nodes
	s.freeAll;
	s.sync;
	s.plotTree;
	s.meter;
	// 5c. NOW READY TO BEGIN PERFORMANCE
	"Done".postln;
});

// **********************************************************************
// 6. PERFORMANCE
// **********************************************************************

// Synth.new(\record, [\out, ~out, \bufnum, ~buffer1.bufnum]);
// Synth.new(\play, [\out, ~out, \bufnum, ~buffer1.bufnum]);
