Class {
	#name : #BaselineOfGToolkit4NeoJSON,
	#superclass : #BaselineOf,
	#category : #BaselineOfGToolkit4NeoJSON
}

{ #category : #accessing }
BaselineOfGToolkit4NeoJSON >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ 
			spec
				baseline: 'NeoJSON'
				with: [ spec repository: 'github://svenvc/NeoJSON:master/repository' ].
			spec 
				package: 'GToolkit4NeoJSON' 
				with: [ spec requires: #('NeoJSON') ] ]
]
