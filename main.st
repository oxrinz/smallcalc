#!/usr/bin/env gst -f

args := Smalltalk arguments.
args isEmpty ifTrue: [
    'Usage: sc 1+"' displayNl.
    ObjectMemory quit.
].

cmd := args first.

(cmd = 'help') ifTrue: [
    'Usage: sc 1+1' displayNl.
    ObjectMemory quit.
].

(cmd = 'version') ifTrue: [
    'smallcalc v0.0.1' displayNl.
    ObjectMemory quit.
].

(cmd = 'h2b') ifTrue: [
    hex := args second asUppercase.

    table := Dictionary new.
    table at: $0 put: '0000'.
    table at: $1 put: '0001'.
    table at: $2 put: '0010'.
    table at: $3 put: '0011'.
    table at: $4 put: '0100'.
    table at: $5 put: '0101'.
    table at: $6 put: '0110'.
    table at: $7 put: '0111'.
    table at: $8 put: '1000'.
    table at: $9 put: '1001'.
    table at: $A put: '1010'.
    table at: $B put: '1011'.
    table at: $C put: '1100'.
    table at: $D put: '1101'.
    table at: $E put: '1110'.
    table at: $F put: '1111'.

    out := String new writeStream.

    hex do: [:c |
        (table includesKey: c) ifFalse: [
            ('Invalid hex: ', c asString) displayNl.
            ObjectMemory quit.
        ].
        out nextPutAll: (table at: c).
    ].

    out contents displayNl.
    ObjectMemory quit.
].

(cmd = 'b2h') ifTrue: [
    bin := args second.

    (bin size \\ 4 ~= 0) ifTrue: [
        'Binary must be a multiple of 4 bits' displayNl.
        ObjectMemory quit.
    ].

    table := Dictionary new.
    table at: '0000' put: $0.
    table at: '0001' put: $1.
    table at: '0010' put: $2.
    table at: '0011' put: $3.
    table at: '0100' put: $4.
    table at: '0101' put: $5.
    table at: '0110' put: $6.
    table at: '0111' put: $7.
    table at: '1000' put: $8.
    table at: '1001' put: $9.
    table at: '1010' put: $A.
    table at: '1011' put: $B.
    table at: '1100' put: $C.
    table at: '1101' put: $D.
    table at: '1110' put: $E.
    table at: '1111' put: $F.

    out := String new writeStream.

    1 to: bin size by: 4 do: [:i |
        nibble := bin copyFrom: i to: i + 3.
        (table includesKey: nibble) ifFalse: [
            ('Invalid 4-bit group: ', nibble) displayNl.
            ObjectMemory quit.
        ].
        out nextPut: (table at: nibble).
    ].

    out contents displayNl.
    ObjectMemory quit.
].

(cmd = 'h2d') ifTrue: [
    hex := args second asUppercase.
    val := Integer readFrom: hex readStream radix: 16.
    val printNl.
    ObjectMemory quit.
].

(cmd = 'b2d') ifTrue: [
    bin := args second.
    val := Integer readFrom: bin readStream radix: 2.
    val printNl.
    ObjectMemory quit.
].

(cmd = 'd2b') ifTrue: [
    dec := args second asInteger.
    out := WriteStream on: String new.
    dec printOn: out base: 2.
    out contents displayNl.
    ObjectMemory quit.
].

(cmd = 'd2h') ifTrue: [
    dec := args second asInteger.
    out := WriteStream on: String new.
    dec printOn: out base: 16.
    out contents asUppercase displayNl.
    ObjectMemory quit.
].

expr := args inject: '' into: [:acc :each |
    acc isEmpty
        ifTrue: [ each ]
        ifFalse: [ acc, ' ', each ]
].

result := Object evaluate: expr.
result displayNl.
