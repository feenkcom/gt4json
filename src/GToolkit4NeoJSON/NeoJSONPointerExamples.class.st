Class {
	#name : #NeoJSONPointerExamples,
	#superclass : #Object,
	#category : #'GToolkit4NeoJSON-Schema'
}

{ #category : #accessing }
NeoJSONPointerExamples >> exampleBiscuits [
	<gtExample>
	<return: #NeoJSONArray>
	| pointer biscuits |
	pointer := NeoJSONPointer new fromString: '/biscuits'.
	biscuits := self exampleJSON atPath: pointer path.
	self assert: biscuits size equals: 2.
	self assert: (biscuits at: 1) notNil.
	self assert: (biscuits at: 2) notNil.
	^ biscuits
]

{ #category : #accessing }
NeoJSONPointerExamples >> exampleChocoLeibniz [
	<gtExample>
	<return: #ByteString>
	| pointer biscuit |
	pointer := NeoJSONPointer new fromString: '/biscuits/1/name'.
	biscuit := self exampleJSON atPath: pointer path.
	self assert: biscuit equals: 'Choco Leibniz'.
	^ biscuit
]

{ #category : #'as yet unclassified' }
NeoJSONPointerExamples >> exampleJSON [
	<gtExample>
	<return: #NeoJSONObject>
	^ NeoJSONObject
		fromString: '{
  "biscuits": [
    { "name": "Digestive" },
    { "name": "Choco Leibniz" }
  ]
}'
]

{ #category : #accessing }
NeoJSONPointerExamples >> exampleRoot [
	<gtExample>
	<return: #NeoJSONObject>
	| pointer root |
	pointer := NeoJSONPointer new.
	self assert: pointer isRoot.
	root := self exampleJSON atPath: pointer path.
	self assert: root equals: self exampleJSON.
	^ root
]
