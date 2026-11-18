Class {
	#name : #GtJsonMissingValue,
	#superclass : #Object,
	#traits : 'TGtUniqueInstance',
	#classTraits : 'TGtUniqueInstance classTrait',
	#category : #'GToolkit4Json-Json - Value'
}

{ #category : #cleanup }
GtJsonMissingValue class >> cleanUniqueInstance [
	self
		gtDo: [ uniqueInstance
				ifNotNil: [ :anInstance | self onRemoveUniqueInstance: anInstance ].
			uniqueInstance := nil ]
		gemstoneDo: [ (SessionTemps current
				at: #GtJsonMissingValue_uniqueInstance
				ifAbsent: [ nil ])
				ifNotNil: [ :anInstance | self onRemoveUniqueInstance: anInstance ].
			SessionTemps current
				removeKey: #GtJsonMissingValue_uniqueInstance
				ifAbsent: [  ] ]
]

{ #category : #testing }
GtJsonMissingValue class >> hasUniqueInstance [
	^ self
		gtDo: [ uniqueInstance isNotNil ]
		gemstoneDo: [ (SessionTemps current at: #GtJsonMissingValue_uniqueInstance ifAbsent: [ nil ])
				isNotNil ]
]

{ #category : #accessing }
GtJsonMissingValue class >> uniqueInstance [
	^ self
		gtDo: [ uniqueInstance ifNil: [ uniqueInstance := self new ] ]
		gemstoneDo: [ SessionTemps current
				at: #GtJsonMissingValue_uniqueInstance
				ifAbsentPut: [ self new ] ]
]

{ #category : #testing }
GtJsonMissingValue >> exists [

	^ false
]
