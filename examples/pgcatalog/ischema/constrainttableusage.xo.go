// Package ischema contains the types for schema 'information_schema'.
package ischema

import "github.com/jlightning/xo/examples/pgcatalog/pgtypes"

// Code generated by xo. DO NOT EDIT.

// ConstraintTableUsage represents a row from 'information_schema.constraint_table_usage'.
type ConstraintTableUsage struct {
	TableCatalog      pgtypes.SQLIdentifier `json:"table_catalog"`      // table_catalog
	TableSchema       pgtypes.SQLIdentifier `json:"table_schema"`       // table_schema
	TableName         pgtypes.SQLIdentifier `json:"table_name"`         // table_name
	ConstraintCatalog pgtypes.SQLIdentifier `json:"constraint_catalog"` // constraint_catalog
	ConstraintSchema  pgtypes.SQLIdentifier `json:"constraint_schema"`  // constraint_schema
	ConstraintName    pgtypes.SQLIdentifier `json:"constraint_name"`    // constraint_name
}
