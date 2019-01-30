{{- $short := (shortname .Name "err" "res" "sqlstr" "db" "XOLog") -}}
{{- $table := (schema .Schema .Table.TableName) -}}
{{- $tableVar := .Table }}
{{- $primaryKey := .PrimaryKey }}
{{- $fkGroup := .ForeignKeyGroup }}
type {{ .Name }} {
{{- range .Fields }}
{{- if ne .GraphqlExcluded true }}
    {{ lowerfirst .Name }}: {{ retypegraphql .Type }} {{- if .Col.NotNull }}!{{- end }}
{{- end }}
{{- end }}

{{- if $fkGroup }}

{{- range $fkGroup.ManyToOneKeys }}
{{- if ne .CallFuncName "" }}
    {{ lowerfirst .FuncName }}(filter: {{ .RefType.Name }}Filter): {{ .RefType.Name }}{{- if .Field.Col.NotNull}}!{{- end }} @filterModifier(module: "{{ .RefType.Table.TableName }}")
{{- end }}
{{- end }}

{{- range $fkGroup.OneToManyKeys }}
{{- if ne .RevertCallFuncName "" }}
    {{- if .IsUnique }}
    {{ lowerfirst .RevertFuncName }}(filter: {{ .Type.Name }}Filter): {{ .Type.Name }}! @filterModifier(module: "{{ .Type.Table.TableName }}")
    {{- else }}
    {{ lowerfirst .RevertFuncName }}(filter: {{ .Type.Name }}Filter, pagination: Pagination): List{{ .Type.Name }}! @filterModifier(module: "{{ .Type.Table.TableName }}")
    {{- end }}
{{- end }}
{{- end }}
{{- end }}
}
input {{ .Name }}Filter {
{{- range .Fields }}
{{- if ne .GraphqlExcluded true }}
{{- if ne .Col.IsVirtualFromConfig true }}
    {{ lowerfirst .Name }}: FilterOnField
{{- end }}
{{- end }}
{{- end }}
}

{{- if canhavecreatestruct .Fields $primaryKey }}
input {{ .Name }}Create {
{{- range .Fields }}
{{- if ne .GraphqlExcluded true }}
{{- if or (ne .Col.IsVirtualFromConfig true) .Col.IsIncludeInCreate }}
    {{- if and (or (ne .Col.ColumnName $primaryKey.Col.ColumnName) $tableVar.ManualPk) (ne .Col.ColumnName "created_at") (ne .Col.ColumnName "updated_at") }}
	{{ lowerfirst .Name }}: {{ retypegraphql .Type }}{{- if .Col.NotNull }}!{{- end }}
	{{- end }}
{{- end }}
{{- end }}
{{- end }}
}

input {{ .Name }}Update {
{{- range .Fields }}
{{- if ne .GraphqlExcluded true }}
{{- if or (ne .Col.IsVirtualFromConfig true) .Col.IsIncludeInUpdate }}
    {{- if and (or (ne .Col.ColumnName $primaryKey.Col.ColumnName) $tableVar.ManualPk) (ne .Col.ColumnName "created_at") (ne .Col.ColumnName "updated_at") }}
	{{ lowerfirst .Name }}: {{ retypegraphql .Type }}
	{{- end }}
{{- end }}
{{- end }}
{{- end }}
}
{{- end }}

type List{{ .Name }} {
    totalCount: Int!
    data: [{{ .Name }}!]!
}
