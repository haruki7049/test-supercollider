(
var server = Server(\nrt,
    options: ServerOptions.new
    .numOutputBusChannels_(2)
    .numInputBusChannels_(2)
);

a = Score.new([
    [0, ['/d_recv',
        SynthDef(\NRTsine, { |out, freq = 440|
            Out.ar(out, SinOsc.ar(freq, 0, 0.2).dup)
        }).asBytes
    ]],
    [0.0, (x = Synth.basicNew(\NRTsine, server, 1000)).newMsg(args: [freq: 269.292])],
    [0.5, x.freeMsg],

    [0.5, (y = Synth.basicNew(\NRTsine, server, 1000)).newMsg(args: [freq: 302.270])],
    [1.0, y.freeMsg],

    [1.0, (y = Synth.basicNew(\NRTsine, server, 1000)).newMsg(args: [freq: 339.286])],
    [1.5, y.freeMsg],

    [2.0, (x = Synth.basicNew(\NRTsine, server, 1000)).newMsg(args: [freq: 269.292])],
    [2.5, x.freeMsg],

    [2.5, (y = Synth.basicNew(\NRTsine, server, 1000)).newMsg(args: [freq: 302.270])],
    [3.0, y.freeMsg],

    [3.0, (y = Synth.basicNew(\NRTsine, server, 1000)).newMsg(args: [freq: 339.286])],
    [3.5, y.freeMsg],
]);

a.recordNRT(
    outputFilePath: "output.wav".standardizePath,
    headerFormat: "wav",
    sampleFormat: "int24",
    options: server.options,
    duration: 4,
    action: { "done".postln }
);

server.remove;

0.exit;
)
