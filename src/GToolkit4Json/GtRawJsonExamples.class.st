Class {
	#name : #GtRawJsonExamples,
	#superclass : #Object,
	#category : #'GToolkit4Json-Examples'
}

{ #category : #'examples - raw json' }
GtRawJsonExamples >> jsonBChild [

	<gtExample>
	| aParent aRawObject |
	aParent := self jsonRoot.
	aRawObject := aParent atKey: #b.

	self assert: aRawObject parent equals: aParent.
	self assert: aRawObject jsonObject equals: (self jsonObject at: #b).

	^ aRawObject
]

{ #category : #'examples - raw json' }
GtRawJsonExamples >> jsonBD1Child [

	<gtExample>
	| aParent aRawObject |
	aParent := self jsonBDChild.
	aRawObject := aParent atIndex: 1.

	self assert: aRawObject parent equals: aParent.
	self
		assert: aRawObject jsonObject
		equals: (((self jsonObject at: #b) at: #d) at: 1).

	^ aRawObject
]

{ #category : #'examples - raw json' }
GtRawJsonExamples >> jsonBD1EChild [

	<gtExample>
	| aParent aRawObject |
	aParent := self jsonBD1Child.
	aRawObject := aParent atKey: #e.

	self assert: aRawObject parent equals: aParent.
	self
		assert: aRawObject jsonObject
		equals: ((((self jsonObject at: #b) at: #d) at: 1) at: #e).

	^ aRawObject
]

{ #category : #'examples - raw json' }
GtRawJsonExamples >> jsonBD1FChild [

	<gtExample>
	| aParent aRawObject |
	aParent := self jsonBD1Child.
	aRawObject := aParent atKey: #f.

	self assert: aRawObject parent equals: aParent.
	self
		assert: aRawObject jsonObject
		equals: ((((self jsonObject at: #b) at: #d) at: 1) at: #f).

	^ aRawObject
]

{ #category : #'examples - raw json' }
GtRawJsonExamples >> jsonBD2Child [

	<gtExample>
	| aParent aRawObject |
	aParent := self jsonBDChild.
	aRawObject := aParent atIndex: 2.

	self assert: aRawObject parent equals: aParent.
	self
		assert: aRawObject jsonObject
		equals: (((self jsonObject at: #b) at: #d) at: 2).

	^ aRawObject
]

{ #category : #'examples - raw json' }
GtRawJsonExamples >> jsonBD2FChild [

	<gtExample>
	| aParent aRawObject |
	aParent := self jsonBD2Child.
	aRawObject := aParent atKey: #f.

	self assert: aRawObject parent equals: aParent.
	self
		assert: aRawObject jsonObject
		equals: ((((self jsonObject at: #b) at: #d) at: 2) at: #f).

	^ aRawObject
]

{ #category : #'examples - raw json' }
GtRawJsonExamples >> jsonBD2GChild [

	<gtExample>
	| aParent aRawObject |
	aParent := self jsonBD2Child.
	aRawObject := aParent atKey: #g.

	self assert: aRawObject parent equals: aParent.
	self
		assert: aRawObject jsonObject
		equals: ((((self jsonObject at: #b) at: #d) at: 2) at: #g).

	^ aRawObject
]

{ #category : #'examples - raw json' }
GtRawJsonExamples >> jsonBD2HChild [

	<gtExample>
	| aParent aRawObject |
	aParent := self jsonBD2Child.
	aRawObject := aParent atKey: #h.

	self assert: aRawObject parent equals: aParent.
	self
		assert: aRawObject jsonObject
		equals: ((((self jsonObject at: #b) at: #d) at: 2) at: #h).

	^ aRawObject
]

{ #category : #'examples - raw json' }
GtRawJsonExamples >> jsonBD2IChild [

	<gtExample>
	| aParent aRawObject |
	aParent := self jsonBD2Child.
	aRawObject := aParent atKey: #i.

	self assert: aRawObject parent equals: aParent.
	self
		assert: aRawObject jsonObject
		equals: ((((self jsonObject at: #b) at: #d) at: 2) at: #i).

	^ aRawObject
]

{ #category : #'examples - raw json' }
GtRawJsonExamples >> jsonBD2JChild [

	<gtExample>
	| aParent aRawObject |
	aParent := self jsonBD2Child.
	aRawObject := aParent atKey: #j.

	self assert: aRawObject parent equals: aParent.
	self
		assert: aRawObject jsonObject
		equals: ((((self jsonObject at: #b) at: #d) at: 2) at: #j).

	^ aRawObject
]

{ #category : #'examples - raw json' }
GtRawJsonExamples >> jsonBD2UnknownMapChild [

	<gtExample>
	| aParent aRawObject |
	aParent := self jsonBD2Child.
	aRawObject := aParent atKey: #unknown.

	self assert: aRawObject parent equals: aParent.
	self
		assert: aRawObject jsonObject
		equals: OrderPreservingDictionary new.

	^ aRawObject
]

{ #category : #'examples - raw json' }
GtRawJsonExamples >> jsonBD2UnknownMapLostChild [

	<gtExample>
	| aParent aRawObject |
	aParent := self jsonBD2UnknownMapChild.
	aRawObject := aParent atKey: #lost.

	self assert: aRawObject parent equals: aParent.
	self
		assert: aRawObject jsonObject
		equals: OrderPreservingDictionary new.

	^ aRawObject
]

{ #category : #'examples - raw json' }
GtRawJsonExamples >> jsonBDChild [

	<gtExample>
	| aParent aRawObject |
	aParent := self jsonBChild.
	aRawObject := aParent atKey: #d.

	self assert: aRawObject parent equals: aParent.
	self
		assert: aRawObject jsonObject
		equals: ((self jsonObject at: #b) at: #d).

	^ aRawObject
]

{ #category : #'examples - json object' }
GtRawJsonExamples >> jsonObject [

	<gtExample>
	^ OrderPreservingDictionary new
		  at: #a put: 'value-a';
		  at: #b put: (OrderPreservingDictionary new
				   at: #c put: 'value-c';
				   at: #d put: { 
						   (OrderPreservingDictionary new
							    at: #e put: 'value-1-e';
							    at: #f put: 'value-1-f';
							    yourself).
						   (OrderPreservingDictionary new
							    at: #e put: 'value-2-e';
							    at: #f put: Float pi;
							    at: #g put: 42;
							    at: #h put: true;
							    at: #i put: false;
							    at: #j put: nil;
							    yourself) };
				   yourself);
		  at: #k put: (OrderPreservingDictionary new
			   at: #l put: 'value-l';
			   at: #m put: 'value-m';
			   yourself);
		  yourself
]

{ #category : #'examples - raw json' }
GtRawJsonExamples >> jsonRoot [

	<gtExample>
	| aRawObject aJsonObject |
	aJsonObject := self jsonObject.
	aRawObject := GtJson forJsonObject: aJsonObject.

	self assert: aRawObject jsonObject equals: aJsonObject.

	^ aRawObject
]
