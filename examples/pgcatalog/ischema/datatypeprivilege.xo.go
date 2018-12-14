// Package ischema contains the types for schema 'information_schema'.
package ischema

import "github.com/JLightning/xo/examples/pgcatalog/pgtypes"

// Code generated by xo. DO NOT EDIT.

// DataTypePrivilege represents a row from 'information_schema.data_type_privileges'.
type DataTypePrivilege struct {
	ObjectCatalog pgtypes.SQLIdentifier `json:"object_catalog"` // object_catalog
	ObjectSchema  pgtypes.SQLIdentifier `json:"object_schema"`  // object_schema
	ObjectName    pgtypes.SQLIdentifier `json:"object_name"`    // object_name
	ObjectType    pgtypes.CharacterData `json:"object_type"`    // object_type
	DtdIdentifier pgtypes.SQLIdentifier `json:"dtd_identifier"` // dtd_identifier
}