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
				spec repository: 'github://svenvc/NeoJSON:b1ca95dcce4c6dc1daff63acc4a14b10f89a7170/repository' ].

		spec package: 'GToolkit4NeoJSON' with: [
			spec requires: #(#NeoJSON) ].
	]
]
