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
				spec repository: 'github://svenvc/NeoJSON:4e0d822bdadb8854f84a2ceb2b9f4e68c8bd6f56/repository' ].
	]
]
