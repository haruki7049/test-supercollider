(
var server = Server(\nrt,
    options: ServerOptions.new
    .numOutputBusChannels_(2)
    .numInputBusChannels_(2)
);

a = Score.new([
    [0, ['/d_recv',
        SynthDef(\NRTsine, { |out, freq = 440|
            Out.ar(out,
                SinOsc.ar(freq: freq) * Line.kr(1, 0, 0.5, doneAction: Done.freeSelf)
            )
        }).asBytes
    ]],
    [0.0, (x = Synth.basicNew(\NRTsine, server, 1000)).newMsg(args: [freq: 269.292])],
    [0.5, x.freeMsg],

    [0.5, (x = Synth.basicNew(\NRTsine, server, 1000)).newMsg(args: [freq: 302.270])],
    [1.0, x.freeMsg],

    [1.0, (x = Synth.basicNew(\NRTsine, server, 1000)).newMsg(args: [freq: 339.286])],
    [1.5, x.freeMsg],

    // 0.5 rest

    [2.0, (x = Synth.basicNew(\NRTsine, server, 1000)).newMsg(args: [freq: 269.292])],
    [2.5, x.freeMsg],

    [2.5, (x = Synth.basicNew(\NRTsine, server, 1000)).newMsg(args: [freq: 302.270])],
    [3.0, x.freeMsg],

    [3.0, (x = Synth.basicNew(\NRTsine, server, 1000)).newMsg(args: [freq: 339.286])],
    [3.5, x.freeMsg],

    // 0.5 rest

    [4.0, (x = Synth.basicNew(\NRTsine, server, 1000)).newMsg(args: [freq: 403.482])],
    [4.5, x.freeMsg],

    [4.5, (x = Synth.basicNew(\NRTsine, server, 1000)).newMsg(args: [freq: 339.286])],
    [5.0, x.freeMsg],

    [5.0, (x = Synth.basicNew(\NRTsine, server, 1000)).newMsg(args: [freq: 302.270])],
    [5.5, x.freeMsg],

    [5.5, (x = Synth.basicNew(\NRTsine, server, 1000)).newMsg(args: [freq: 269.292])],
    [6.0, x.freeMsg],

    [6.0, (x = Synth.basicNew(\NRTsine, server, 1000)).newMsg(args: [freq: 302.270])],
    [6.5, x.freeMsg],

    [6.5, (x = Synth.basicNew(\NRTsine, server, 1000)).newMsg(args: [freq: 339.286])],
    [7.0, x.freeMsg],

    [7.0, (x = Synth.basicNew(\NRTsine, server, 1000)).newMsg(args: [freq: 302.270])],
    [7.5, x.freeMsg],
]);

a.recordNRT(
    outputFilePath: "output.wav".standardizePath,
    headerFormat: "wav",
    sampleFormat: "int24",
    options: server.options,
    duration: 8,
    action: { "done".postln }
);

server.remove;

0.exit;
)
