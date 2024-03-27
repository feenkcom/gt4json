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
				spec repository: 'github://svenvc/NeoJSON:c09b91c901ec94e74c6fbd55247cce3f3d0d42b0/repository' ].

		spec package: 'GToolkit4NeoJSON' with: [
			spec requires: #('NeoJSON') ].
	]
]
