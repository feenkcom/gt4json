Class {
	#name : #NeoJSONPatchExamples,
	#superclass : #Object,
	#category : #'GToolkit4NeoJSON-Schema'
}

{ #category : #accessing }
NeoJSONPatchExamples >> exampleAddPatch [
	<gtExample>
	^ NeoJSONObject fromString: '{ "op": "add", "path": "/email", "value": "bob@example.com" }'
]

{ #category : #accessing }
NeoJSONPatchExamples >> exampleApplyAddPatch [
	<gtExample>
	| source target patch result |
	source := self exampleDocument.
	patch := NeoJSONPatch new fromDictionary: self exampleAddPatch.
	result := patch applyTo: source.
	target := NeoJSONObject fromString: 
'{
  "user": {
    "name": "Bob",
    "age": 25
  },
  "email": "bob@example.com"
}'.
	self assert: result equals: target.
	^ result
]

{ #category : #accessing }
NeoJSONPatchExamples >> exampleApplyCopyPatch [
	<gtExample>
	| source target patch result |
	source := self exampleDocument.
	patch := NeoJSONPatch new fromDictionary: self exampleCopyPatch.
	result := patch applyTo: source.
	target := NeoJSONObject fromString: 
'{
  "user": {
    "name": "Bob",
    "age": 25
  },
  "displayName": "Bob"
}'.
	self assert: result equals: target.
	^ result
]

{ #category : #accessing }
NeoJSONPatchExamples >> exampleApplyMovePatch [
	<gtExample>
	| source target patch result |
	source := self exampleDocument.
	patch := NeoJSONPatch new fromDictionary: self exampleMovePatch.
	result := patch applyTo: source.
	target := NeoJSONObject fromString: 
'{
  "user": {
    "name": "Bob",
    "birthYear": 25
  }
}'.
	self assert: result equals: target.
	^ result
]

{ #category : #accessing }
NeoJSONPatchExamples >> exampleApplyRemovePatch [
	<gtExample>
	| source target patch result |
	source := self exampleDocument.
	patch := NeoJSONPatch new fromDictionary: self exampleRemovePatch.
	result := patch applyTo: source.
	target := NeoJSONObject fromString: 
'{
  "user": {
    "name": "Bob"
  }
}'.
	self assert: result equals: target.
	^ result
]

{ #category : #accessing }
NeoJSONPatchExamples >> exampleApplyReplacePatch [
	<gtExample>
	| source target patch result |
	source := self exampleDocument.
	patch := NeoJSONPatch new fromDictionary: self exampleReplacePatch.
	result := patch applyTo: source.
	target := NeoJSONObject fromString: 
'{
  "user": {
    "name": "Alice",
    "age": 25
  }
}'.
	self assert: result equals: target.
	^ result
]

{ #category : #accessing }
NeoJSONPatchExamples >> exampleApplyTestPatch [
	<gtExample>
	| source patch failed |
	source := self exampleDocument.
	patch := NeoJSONPatch new fromDictionary: self exampleTestPatch.
	failed := false.
	[ patch applyTo: source ] on: AssertionFailure do: [ failed := true ].
	self assert: failed.
	source := self exampleApplyAddPatch.
	self assert: (patch applyTo: source)
]

{ #category : #accessing }
NeoJSONPatchExamples >> exampleCopyPatch [
	<gtExample>
	^ NeoJSONObject fromString: '{ "op": "copy", "from": "/user/name", "path": "/displayName" }'
]

{ #category : #accessing }
NeoJSONPatchExamples >> exampleDocument [
	<gtExample>
	^ NeoJSONObject fromString:
'{
  "user": {
    "name": "Bob",
    "age": 25
  }
}'
]

{ #category : #accessing }
NeoJSONPatchExamples >> exampleMovePatch [
	<gtExample>
	^ NeoJSONObject fromString: '{ "op": "move", "from": "/user/age", "path": "/user/birthYear" }'
]

{ #category : #accessing }
NeoJSONPatchExamples >> exampleRemovePatch [
	<gtExample>
	^ NeoJSONObject fromString: '{ "op": "remove", "path": "/user/age" }'
]

{ #category : #accessing }
NeoJSONPatchExamples >> exampleReplacePatch [
	<gtExample>
	^ NeoJSONObject fromString: '{ "op": "replace", "path": "/user/name", "value": "Alice" }'
]

{ #category : #accessing }
NeoJSONPatchExamples >> exampleTestPatch [
	<gtExample>
	^ NeoJSONObject fromString: '{ "op": "test", "path": "/email", "value": "bob@example.com" }'
]
