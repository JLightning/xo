// Package ischema contains the types for schema 'information_schema'.
package ischema

import "xo/examples/pgcatalog/pgtypes"

// Code generated by xo. DO NOT EDIT.

// CollationCharacterSetApplicability represents a row from 'information_schema.collation_character_set_applicability'.
type CollationCharacterSetApplicability struct {
	CollationCatalog    pgtypes.SQLIdentifier `json:"collation_catalog"`     // collation_catalog
	CollationSchema     pgtypes.SQLIdentifier `json:"collation_schema"`      // collation_schema
	CollationName       pgtypes.SQLIdentifier `json:"collation_name"`        // collation_name
	CharacterSetCatalog pgtypes.SQLIdentifier `json:"character_set_catalog"` // character_set_catalog
	CharacterSetSchema  pgtypes.SQLIdentifier `json:"character_set_schema"`  // character_set_schema
	CharacterSetName    pgtypes.SQLIdentifier `json:"character_set_name"`    // character_set_name
}
