"
Examples for GtJsonShapeComparison.
"
Class {
	#name : #GtJsonShapeComparisonExamples,
	#superclass : #Object,
	#category : #'GToolkit4Json-Examples'
}

{ #category : #examples }
GtJsonShapeComparisonExamples >> arraySizeAndElementShape [
	<gtExample>
	<return: #GtJsonShapeComparison>
	| comparison paths |
	comparison := GtJsonShapeComparison
		compareJsonString: '{"items":[{"id":1,"label":"one"},{"id":2,"label":"two"}]}'
		withJsonString: '{"items":[{"id":3,"label":"three"},{"id":"4"},{"id":5,"label":"five"}]}'.
	paths := comparison differences collect: #key.
	self assert: comparison matches not.
	self assert: comparison differences size equals: 3.
	self assert: (paths includes: '$.items').
	self assert: (paths includes: '$.items[2].id').
	self assert: (paths includes: '$.items[2].label').
	^ comparison
]

{ #category : #examples }
GtJsonShapeComparisonExamples >> differentScalarKinds [
	<gtExample>
	<return: #GtJsonShapeComparison>
	| comparison |
	comparison := GtJsonShapeComparison
		compareJsonString: '{"age":37}'
		withJsonString: '{"age":"37"}'.
	self assert: comparison matches not.
	self assert: comparison differences size equals: 1.
	self assert: comparison differences first key equals: '$.age'.
	self assert: comparison differences first value equals: 'expected number but found string'.
	^ comparison
]

{ #category : #examples }
GtJsonShapeComparisonExamples >> matchingObjectsIgnoreValues [
	<gtExample>
	<return: #GtJsonShapeComparison>
	| comparison |
	comparison := GtJsonShapeComparison
		compareJsonString: '{"name":"Ada","age":37,"active":true}'
		withJsonString: '{"name":"Grace","age":85,"active":false}'.
	self assert: comparison matches.
	self assert: comparison differences isEmpty.
	^ comparison
]

{ #category : #examples }
GtJsonShapeComparisonExamples >> missingAndExtraKeys [
	<gtExample>
	<return: #GtJsonShapeComparison>
	| comparison paths |
	comparison := GtJsonShapeComparison
		compareJsonString: '{"name":"Ada","address":{"city":"London","zip":"NW1"}}'
		withJsonString: '{"name":"Ada","address":{"city":"London","country":"UK"}}'.
	paths := comparison differences collect: #key.
	self assert: comparison matches not.
	self assert: comparison differences size equals: 2.
	self assert: (paths includes: '$.address.zip').
	self assert: (paths includes: '$.address.country').
	^ comparison
]
