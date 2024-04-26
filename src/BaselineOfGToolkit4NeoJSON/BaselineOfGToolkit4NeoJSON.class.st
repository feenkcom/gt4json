Class {
	#name : #BaselineOfGToolkit4NeoJSON,
	#superclass : #BaselineOf,
	#category : #BaselineOfGToolkit4NeoJSON
}

{ #category : #baseline }
BaselineOfGToolkit4NeoJSON >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec
			baseline: 'NeoJSON' with: [
				spec repository: 'github://svenvc/NeoJSON:17efabc2fdb0c2469bb348e79b363c3f91441ac7/repository' ].

		spec package: 'GToolkit4NeoJSON' with: [
			spec requires: #('NeoJSON') ].
	]
]
