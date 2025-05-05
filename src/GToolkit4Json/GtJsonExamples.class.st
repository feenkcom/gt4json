Class {
	#name : #GtJsonExamples,
	#superclass : #Object,
	#category : #'GToolkit4Json-Examples'
}

{ #category : #'examples - modifications' }
GtJsonExamples >> jsonAddDoubleUnknownPathKey [
	<gtExample>
	<return: #GtJson>
	| aRawObject |
	aRawObject := self jsonRoot.

	self assert: (aRawObject atPath: #(z za zaa)) exists not.

	aRawObject atPath: #(z za zaa) put: 9.

	self assert: (aRawObject atPath: #(z za zaa)) exists.
	self assert: (aRawObject atPath: #(z za zaa)) jsonObject equals: 9.

	^ aRawObject
]

{ #category : #'examples - modifications' }
GtJsonExamples >> jsonAddNewRootKey [
	<gtExample>
	<return: #GtJson>
	| aRawObject |
	aRawObject := self jsonRoot.

	self assert: (aRawObject at: #z) exists not.

	aRawObject at: #z put: 'new value-z'.

	self assert: (aRawObject at: #z) exists.
	self assert: (aRawObject at: #z) jsonObject equals: 'new value-z'.

	^ aRawObject
]

{ #category : #'examples - modifications' }
GtJsonExamples >> jsonAddPathIndex [
	<gtExample>
	<return: #GtJson>
	| aRawObject |
	aRawObject := self jsonRoot.

	self assert: (aRawObject atPath: #(b d 3)) exists not.

	aRawObject atPath: #(b d 3) put: 21.

	self assert: (aRawObject atPath: #(b d 3)) exists.
	self assert: (aRawObject atPath: #(b d 3)) jsonObject equals: 21.

	^ aRawObject
]

{ #category : #'examples - modifications' }
GtJsonExamples >> jsonAddTripleUnknownPathIndex [
	<gtExample>
	<return: #GtJson>
	| aRawObject anArraySize aPath |
	aRawObject := self jsonRoot.

	anArraySize := (aRawObject atPath: #(b d)) jsonObject size.
	aPath := {#b.
			#d.
			anArraySize + 3.
			#z.
			2.
			3.
			1}.
	self assert: (aRawObject atPath: aPath) exists not.

	aRawObject atPath: aPath put: 9.

	self assert: (aRawObject atPath: aPath) exists.
	self assert: (aRawObject atPath: aPath) jsonObject equals: 9.

	^ aRawObject
]

{ #category : #'examples - modifications' }
GtJsonExamples >> jsonAddTripleUnknownPathKey [
	<gtExample>
	<return: #GtJson>
	| aRawObject anArraySize aPath |
	aRawObject := self jsonRoot.

	anArraySize := (aRawObject atPath: #(b d)) jsonObject size.
	aPath := {#b.
			#d.
			anArraySize + 3.
			#z.
			#za.
			#zaa.
			#zaaa}.
	self assert: (aRawObject atPath: aPath) exists not.

	aRawObject atPath: aPath put: 9.

	self assert: (aRawObject atPath: aPath) exists.
	self assert: (aRawObject atPath: aPath) jsonObject equals: 9.

	^ aRawObject
]

{ #category : #'examples - modifications' }
GtJsonExamples >> jsonAddUnknownPathKey [
	<gtExample>
	<return: #GtJson>
	| aRawObject |
	aRawObject := self jsonRoot.

	self assert: (aRawObject atPath: #(z za)) exists not.

	aRawObject atPath: #(z za) put: 9.

	self assert: (aRawObject atPath: #(z za)) exists.
	self assert: (aRawObject atPath: #(z za)) jsonObject equals: 9.

	^ aRawObject
]

{ #category : #'examples - enumeration' }
GtJsonExamples >> jsonAllLeafValuesIteration_jsonRoot [
	<gtExample>
	<return: #OrderedCollection>
	| aJson allValues |
	aJson := self jsonRoot.
	allValues := OrderedCollection new.
	self assert: aJson exists.

	aJson
		allLeafValuesDepthFirstDo: [ :aValue :aKey :aParent :aChild | 
			allValues
				add: {aValue.
						aKey.
						aParent.
						aChild} ].

	self assert: allValues size equals: 12.
	self assert: allValues first first equals: 'value-a'.
	self assert: allValues second first equals: 'value-c'.
	self assert: allValues third first equals: 'value-1-e'.
	self assert: allValues fourth first equals: 'value-1-f'.

	self assert: allValues last first equals: 'value-m'.

	^ allValues
]

{ #category : #'examples - enumeration' }
GtJsonExamples >> jsonAllValuesIteration_collection [
	<gtExample>
	<return: #OrderedCollection>
	| aJson allValues |
	aJson := GtJson forJsonObject: Array empty.
	allValues := OrderedCollection new.
	self assert: aJson exists.

	aJson
		allValuesDepthFirstDo: [ :aValue :aKey :aParent :aChild | 
			allValues
				add: {aValue.
						aKey.
						aParent.
						aChild} ].

	self assert: allValues size equals: 1.
	self
		assert: allValues first
		equals: {Array empty.
				nil.
				nil.
				aJson}.

	^ allValues
]

{ #category : #'examples - enumeration' }
GtJsonExamples >> jsonAllValuesIteration_dictionary [
	<gtExample>
	<return: #OrderedCollection>
	| aJson allValues |
	aJson := GtJson forJsonObject: Dictionary new.
	allValues := OrderedCollection new.
	self assert: aJson exists.

	aJson
		allValuesDepthFirstDo: [ :aValue :aKey :aParent :aChild | 
			allValues
				add: {aValue.
						aKey.
						aParent.
						aChild} ].

	self assert: allValues size equals: 1.
	self
		assert: allValues first
		equals: {Dictionary new.
				nil.
				nil.
				aJson}.

	^ allValues
]

{ #category : #'examples - enumeration' }
GtJsonExamples >> jsonAllValuesIteration_integer [
	<gtExample>
	<return: #OrderedCollection>
	| aJson allValues |
	aJson := GtJson forJsonObject: 108.
	allValues := OrderedCollection new.
	self assert: aJson exists.

	aJson
		allValuesDepthFirstDo: [ :aValue :aKey :aParent :aChild | 
			allValues
				add: {aValue.
						aKey.
						aParent.
						aChild} ].

	self assert: allValues size equals: 1.
	self
		assert: allValues first
		equals: {108.
				nil.
				nil.
				aJson}.

	^ allValues
]

{ #category : #'examples - enumeration' }
GtJsonExamples >> jsonAllValuesIteration_jsonRoot [
	<gtExample>
	<return: #OrderedCollection>
	| aJson allValues |
	aJson := self jsonRoot.
	allValues := OrderedCollection new.
	self assert: aJson exists.

	aJson
		allValuesDepthFirstDo: [ :aValue :aKey :aParent :aChild | 
			allValues
				add: {aValue.
						aKey.
						aParent.
						aChild} ].

	self assert: allValues size equals: 18.
	self assert: allValues first first equals: 'value-a'.
	self assert: allValues second first equals: 'value-c'.
	self assert: allValues third first equals: 'value-1-e'.
	self assert: allValues fourth first equals: 'value-1-f'.

	self assert: allValues last first equals: aJson jsonObject.

	^ allValues
]

{ #category : #'examples - enumeration' }
GtJsonExamples >> jsonAllValuesIteration_notExisting [
	<gtExample>
	<return: #GtJson>
	| aJson allValues |
	aJson := GtJson new.
	allValues := OrderedCollection new.

	self assert: aJson exists not.

	aJson allValuesDepthFirstDo: [ :aValue | allValues add: aValue ].

	self assert: allValues size equals: 0.

	^ aJson
]

{ #category : #'examples - enumeration' }
GtJsonExamples >> jsonAllValuesIteration_string [
	<gtExample>
	<return: #OrderedCollection>
	| aJson allValues |
	aJson := GtJson forJsonObject: 'value'.
	allValues := OrderedCollection new.
	self assert: aJson exists.

	aJson
		allValuesDepthFirstDo: [ :aValue :aKey :aParent :aChild | 
			allValues
				add: {aValue.
						aKey.
						aParent.
						aChild} ].

	self assert: allValues size equals: 1.
	self
		assert: allValues first
		equals: {'value'.
				nil.
				nil.
				aJson}.

	^ allValues
]

{ #category : #'examples - enumeration' }
GtJsonExamples >> jsonAllValuesIteration_unknown [
	<gtExample>
	<return: #GtJsonKey>
	| aJson allValues aRoot |
	aRoot := GtJson forJsonObject: Dictionary new.
	aJson := aRoot at: #uknown.
	allValues := OrderedCollection new.
	self assert: aJson exists not.

	aJson
		allValuesDepthFirstDo: [ :aValue :aKey :aParent :aChild | 
			allValues
				add: {aValue.
						aKey.
						aParent.
						aChild} ].

	self assert: allValues size equals: 0.

	^ aJson
]

{ #category : #'examples - modifications' }
GtJsonExamples >> jsonAppNewPathKey [
	<gtExample>
	<return: #GtJson>
	| aRawObject |
	aRawObject := self jsonRoot.

	self assert: (aRawObject atPath: #(b d 2 gg)) exists not.

	aRawObject atPath: #(b d 2 gg) put: 'new value-gg'.

	self assert: (aRawObject atPath: #(b d 2 gg)) exists.
	self assert: (aRawObject atPath: #(b d 2 gg)) jsonObject equals: 'new value-gg'.

	^ aRawObject
]

{ #category : #'examples - json' }
GtJsonExamples >> jsonBChild [
	<gtExample>
	<return: #GtJsonKey>
	| aParent aRawObject |
	aParent := self jsonRoot.
	aRawObject := aParent at: #b.

	self assert: aRawObject parent equals: aParent.
	self assert: aRawObject jsonObject equals: (self jsonObject at: #b).

	^ aRawObject
]

{ #category : #'examples - json' }
GtJsonExamples >> jsonBD1Child [
	<gtExample>
	<return: #GtJsonIndex>
	| aParent aRawObject |
	aParent := self jsonBDChild.
	aRawObject := aParent at: 1.

	self assert: aRawObject parent equals: aParent.
	self
		assert: aRawObject jsonObject
		equals: (((self jsonObject at: #b) at: #d) at: 1).

	^ aRawObject
]

{ #category : #'examples - json' }
GtJsonExamples >> jsonBD1EChild [
	<gtExample>
	<return: #GtJsonKey>
	| aParent aRawObject |
	aParent := self jsonBD1Child.
	aRawObject := aParent at: #e.

	self assert: aRawObject parent equals: aParent.
	self
		assert: aRawObject jsonObject
		equals: ((((self jsonObject at: #b) at: #d) at: 1) at: #e).

	^ aRawObject
]

{ #category : #'examples - json' }
GtJsonExamples >> jsonBD1FChild [
	<gtExample>
	<return: #GtJsonKey>
	| aParent aRawObject |
	aParent := self jsonBD1Child.
	aRawObject := aParent at: #f.

	self assert: aRawObject parent equals: aParent.
	self
		assert: aRawObject jsonObject
		equals: ((((self jsonObject at: #b) at: #d) at: 1) at: #f).

	^ aRawObject
]

{ #category : #'examples - json' }
GtJsonExamples >> jsonBD2Child [
	<gtExample>
	<return: #GtJsonIndex>
	| aParent aRawObject |
	aParent := self jsonBDChild.
	aRawObject := aParent at: 2.

	self assert: aRawObject parent equals: aParent.
	self
		assert: aRawObject jsonObject
		equals: (((self jsonObject at: #b) at: #d) at: 2).

	^ aRawObject
]

{ #category : #'examples - json' }
GtJsonExamples >> jsonBD2FChild [
	<gtExample>
	<return: #GtJsonKey>
	| aParent aRawObject |
	aParent := self jsonBD2Child.
	aRawObject := aParent at: #f.

	self assert: aRawObject parent equals: aParent.
	self
		assert: aRawObject jsonObject
		equals: ((((self jsonObject at: #b) at: #d) at: 2) at: #f).

	^ aRawObject
]

{ #category : #'examples - json' }
GtJsonExamples >> jsonBD2GChild [
	<gtExample>
	<return: #GtJsonKey>
	| aParent aRawObject |
	aParent := self jsonBD2Child.
	aRawObject := aParent at: #g.

	self assert: aRawObject parent equals: aParent.
	self
		assert: aRawObject jsonObject
		equals: ((((self jsonObject at: #b) at: #d) at: 2) at: #g).

	^ aRawObject
]

{ #category : #'examples - json' }
GtJsonExamples >> jsonBD2HChild [
	<gtExample>
	<return: #GtJsonKey>
	| aParent aRawObject |
	aParent := self jsonBD2Child.
	aRawObject := aParent at: #h.

	self assert: aRawObject parent equals: aParent.
	self
		assert: aRawObject jsonObject
		equals: ((((self jsonObject at: #b) at: #d) at: 2) at: #h).

	^ aRawObject
]

{ #category : #'examples - json' }
GtJsonExamples >> jsonBD2IChild [
	<gtExample>
	<return: #GtJsonKey>
	| aParent aRawObject |
	aParent := self jsonBD2Child.
	aRawObject := aParent at: #i.

	self assert: aRawObject parent equals: aParent.
	self
		assert: aRawObject jsonObject
		equals: ((((self jsonObject at: #b) at: #d) at: 2) at: #i).

	^ aRawObject
]

{ #category : #'examples - json' }
GtJsonExamples >> jsonBD2JChild [
	<gtExample>
	<return: #GtJsonKey>
	| aParent aRawObject |
	aParent := self jsonBD2Child.
	aRawObject := aParent at: #j.

	self assert: aRawObject parent equals: aParent.
	self
		assert: aRawObject jsonObject
		equals: ((((self jsonObject at: #b) at: #d) at: 2) at: #j).

	^ aRawObject
]

{ #category : #'examples - json' }
GtJsonExamples >> jsonBD2UnknownMapChild [
	<gtExample>
	<return: #GtJsonKey>
	| aParent aRawObject |
	aParent := self jsonBD2Child.
	aRawObject := aParent at: #unknown.

	self assert: aRawObject parent equals: aParent.
	self assert: aRawObject exists not.
	self assert: aRawObject jsonObject equals: nil.

	^ aRawObject
]

{ #category : #'examples - json' }
GtJsonExamples >> jsonBD2UnknownMapLostChild [
	<gtExample>
	<return: #GtJsonUnknown>
	| aParent aRawObject |
	aParent := self jsonBD2UnknownMapChild.
	aRawObject := aParent at: #lost.

	self assert: aRawObject parent equals: aParent.
	self assert: aRawObject exists not.
	self assert: aRawObject jsonObject equals: nil.

	^ aRawObject
]

{ #category : #'examples - json' }
GtJsonExamples >> jsonBDChild [
	<gtExample>
	<return: #GtJsonKey>
	| aParent aRawObject |
	aParent := self jsonBChild.
	aRawObject := aParent at: #d.

	self assert: aRawObject parent equals: aParent.
	self assert: aRawObject jsonObject equals: ((self jsonObject at: #b) at: #d).

	^ aRawObject
]

{ #category : #'examples - modifications' }
GtJsonExamples >> jsonModifyPathIndex [
	<gtExample>
	<return: #GtJson>
	| aRawObject |
	aRawObject := self jsonRoot.

	self assert: (aRawObject atPath: #(b d 2)) exists.

	aRawObject atPath: #(b d 2) put: 12.

	self assert: (aRawObject atPath: #(b d 2)) exists.
	self assert: (aRawObject atPath: #(b d 2)) jsonObject equals: 12.

	^ aRawObject
]

{ #category : #'examples - modifications' }
GtJsonExamples >> jsonModifyPathKey [
	<gtExample>
	<return: #GtJson>
	| aRawObject |
	aRawObject := self jsonRoot.

	self assert: (aRawObject atPath: #(b d 2 g)) exists.

	aRawObject atPath: #(b d 2 g) put: 108.

	self assert: (aRawObject atPath: #(b d 2 g)) exists.
	self assert: (aRawObject atPath: #(b d 2 g)) jsonObject equals: 108.

	^ aRawObject
]

{ #category : #'examples - modifications' }
GtJsonExamples >> jsonModifyRootKeyValue [
	<gtExample>
	<return: #GtJson>
	| aRawObject |
	aRawObject := self jsonRoot.

	self assert: (aRawObject at: #a) exists.
	aRawObject at: #a put: 'new value-a'.

	self assert: (aRawObject at: #a) exists.
	self assert: (aRawObject at: #a) jsonObject equals: 'new value-a'.

	^ aRawObject
]

{ #category : #'examples - json object' }
GtJsonExamples >> jsonObject [
	<gtExample>
	<return: #OrderedDictionary>
	^ OrderedDictionary new
		at: #a put: 'value-a';
		at: #b
			put: (OrderedDictionary new
					at: #c put: 'value-c';
					at: #d
						put: {OrderedDictionary new
									at: #e put: 'value-1-e';
									at: #f put: 'value-1-f';
									yourself.
								OrderedDictionary new
									at: #e put: 'value-2-e';
									at: #f put: Float pi;
									at: #g put: 42;
									at: #h put: true;
									at: #i put: false;
									at: #j put: nil;
									yourself};
					yourself);
		at: #k
			put: (OrderedDictionary new
					at: #l put: 'value-l';
					at: #m put: 'value-m';
					yourself);
		yourself
]

{ #category : #'examples - json' }
GtJsonExamples >> jsonRoot [
	<gtExample>
	<return: #GtJson>
	| aRawObject aJsonObject |
	aJsonObject := self jsonObject.
	aRawObject := GtJson forJsonObject: aJsonObject.

	self assert: aRawObject jsonObject equals: aJsonObject.
	self assert: aRawObject exists.

	^ aRawObject
]

{ #category : #'examples - person' }
GtJsonExamples >> personJson [
	<gtExample>
	<return: #GtJson>
	| aJsonObject aJson |
	aJsonObject := self personJsonObject.
	aJson := GtJson forJsonObject: aJsonObject.

	self assert: aJson jsonObject equals: aJsonObject.
	self assert: (aJson at: #birthday) jsonObject equals: '12 June 2001'.
	self assert: aJson birthday jsonObject equals: '12 June 2001'.

	^ aJson
]

{ #category : #'examples - person' }
GtJsonExamples >> personJsonObject [
	<gtExample>
	<return: #OrderedDictionary>
	^ OrderedDictionary new
		at: #firstName put: 'Joe';
		at: #familyName put: 'Doe';
		at: #birthday put: '12 June 2001';
		at: #addresses
			put: {OrderedDictionary new
						at: #street put: 'Kopernikova 345';
						at: #city put: 'Bratislava';
						yourself.
					OrderedDictionary new
						at: #street put: 'Havlova 89';
						at: #city put: 'Praha';
						at: #is_primary put: true;
						yourself};
		yourself
]

{ #category : #'examples - person' }
GtJsonExamples >> personKeyedAddressesJson [
	<gtExample>
	<return: #GtJson>
	| aJsonObject aJson |
	aJsonObject := self personKeyedAddressesJsonObject.
	aJson := GtJson forJsonObject: aJsonObject.

	self assert: aJson jsonObject equals: aJsonObject.
	self assert: (aJson at: #birthday) jsonObject equals: '12 June 2001'.
	self assert: aJson birthday jsonObject equals: '12 June 2001'.

	self
		assert: (aJson atPath: #(addresses home street)) jsonObject
		equals: 'Kopernikova 345'.
	self assert: aJson addresses home street jsonObject equals: 'Kopernikova 345'.

	self assert: aJson addresses work street jsonObject equals: 'Havlova 89'.

	^ aJson
]

{ #category : #'examples - person' }
GtJsonExamples >> personKeyedAddressesJsonObject [
	<gtExample>
	<return: #OrderedDictionary>
	^ OrderedDictionary new
		at: #firstName put: 'Joe';
		at: #familyName put: 'Doe';
		at: #birthday put: '12 June 2001';
		at: #addresses
			put: (OrderedDictionary new
					at: #home
						put: (OrderedDictionary new
								at: #street put: 'Kopernikova 345';
								at: #city put: 'Bratislava';
								yourself);
					at: #work
						put: (OrderedDictionary new
								at: #street put: 'Havlova 89';
								at: #city put: 'Praha';
								at: #is_primary put: true;
								yourself);
					yourself);
		yourself
]

{ #category : #'examples - person' }
GtJsonExamples >> personTwoJsonObject [
	<gtExample>
	<return: #OrderedDictionary>
	^ OrderedDictionary new
		at: #firstName put: 'Jim';
		at: #familyName put: 'Doe';
		at: #birthday put: '21 June 2021';
		at: #addresses
			put: {OrderedDictionary new
						at: #street put: 'Vladimírova 108';
						at: #city put: 'Košice';
						yourself.
					OrderedDictionary new
						at: #street put: 'Havlova 89';
						at: #city put: 'Praha';
						at: #is_primary put: true;
						yourself};
		yourself
]

{ #category : #'examples - person' }
GtJsonExamples >> personsJson [
	<gtExample>
	<return: #GtJson>
	| aJsonObject aJson |
	aJsonObject := self personsJsonObject.
	aJson := GtJson forJsonObject: aJsonObject.

	self assert: aJson jsonObject equals: aJsonObject.
	self assert: (aJson atPath: #(1 #birthday)) jsonObject equals: '12 June 2001'.
	self assert: (aJson at: 1) birthday jsonObject equals: '12 June 2001'.

	^ aJson
]

{ #category : #'examples - person' }
GtJsonExamples >> personsJsonObject [
	<gtExample>
	<return: #Array>
	^ Array with: self personJsonObject with: self personTwoJsonObject
]

{ #category : #'examples - person' }
GtJsonExamples >> simplePersonJsonObject [
	<gtExample>
	<return: #OrderedDictionary>
	^ OrderedDictionary new
		at: #firstName put: 'Joe';
		at: #familyName put: 'Doe';
		at: #birthday put: '12 June 2001';
		at: #address
			put: (OrderedDictionary new
					at: #street put: 'Kopernikova 345';
					at: #city put: 'Bratislava';
					yourself);
		yourself
]
