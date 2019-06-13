func UnmarshalDatetime(v interface{}) (time.Time, error) {
	if str, ok := v.(string); ok {
		layout := "2006-01-02 15:04:05"
        result, err := time.ParseInLocation(layout, str, time.Local)
        if err == nil {
            return result, err
        }

        layout = "2006-01-02"
        result, err = time.ParseInLocation(layout, str, time.Local)
        if err == nil {
            return result, err
        }

        layout = "15:04:05"
        return time.ParseInLocation(layout, str, time.Local)
	}
	return time.Time{}, errors.New("time should be a unix timestamp")
}

func MarshalDatetime(t time.Time) graphql.Marshaler {
	return graphql.WriterFunc(func(w io.Writer) {
		io.WriteString(w, `"`+t.Format("2006-01-02 15:04:05")+`"`)
	})
}

func UnmarshalIntBool(v interface{}) (int8, error) {
	if value, ok := v.(bool); ok {
		if value {
			return 1, nil
		}
		return 0, nil
	}
	return 0, errors.New("value is not boolean")
}

func MarshalIntBool(v int8) graphql.Marshaler {
	return graphql.WriterFunc(func(w io.Writer) {
		if v == 1 {
			io.WriteString(w, "true")
		} else {
			io.WriteString(w, "false")
		}
	})
}

func UnmarshalNullInt64(v interface{}) (sql.NullInt64, error) {
	nullInt64 := sql.NullInt64{}
	if v == nil {
		return nullInt64, nil
	}
	if value, ok := v.(int64); ok {
		nullInt64.Valid = true
		nullInt64.Int64 = value
		return nullInt64, nil
	}
	return nullInt64, errors.New("value is not integer")
}

func MarshalNullInt64(v sql.NullInt64) graphql.Marshaler {
	return graphql.WriterFunc(func(w io.Writer) {
		if v.Valid {
			io.WriteString(w, fmt.Sprint(v.Int64))
		} else {
			io.WriteString(w, "null")
		}
	})
}

func UnmarshalNullFloat64(v interface{}) (sql.NullFloat64, error) {
	nullFloat64 := sql.NullFloat64{}
	if v == nil {
		return nullFloat64, nil
	}
	if value, ok := v.(float64); ok {
		nullFloat64.Valid = true
		nullFloat64.Float64 = float64(value)
		return nullFloat64, nil
	}
	return nullFloat64, errors.New("value is not float64")
}

func MarshalNullFloat64(v sql.NullFloat64) graphql.Marshaler {
	return graphql.WriterFunc(func(w io.Writer) {
		if v.Valid {
			io.WriteString(w, fmt.Sprint(v.Float64))
		} else {
			io.WriteString(w, "null")
		}
	})
}

func UnmarshalNullString(v interface{}) (sql.NullString, error) {
	nullString := sql.NullString{}
	if v == nil {
		return nullString, nil
	}
	if value, ok := v.(string); ok {
		nullString.Valid = true
		nullString.String = value
		return nullString, nil
	}
	return nullString, errors.New("value is not string")
}

func MarshalNullString(v sql.NullString) graphql.Marshaler {
	return graphql.WriterFunc(func(w io.Writer) {
		if v.Valid {
			io.WriteString(w, `"`+v.String+`"`)
		} else {
			io.WriteString(w, "null")
		}
	})
}

func UnmarshalNullBool(v interface{}) (sql.NullBool, error) {
	nullBool := sql.NullBool{}
	if v == nil {
		return nullBool, nil
	}
	if value, ok := v.(bool); ok {
		nullBool.Valid = true
		nullBool.Bool = value
		return nullBool, nil
	}
	return nullBool, errors.New("value is not bool")
}

func MarshalNullBool(v sql.NullBool) graphql.Marshaler {
	return graphql.WriterFunc(func(w io.Writer) {
		if v.Valid {
			io.WriteString(w, fmt.Sprint(v.Bool))
		} else {
			io.WriteString(w, "null")
		}
	})
}

func MarshalNullTime(t mysql.NullTime) graphql.Marshaler {
	return graphql.WriterFunc(func(w io.Writer) {
		if t.Valid {
			io.WriteString(w, `"`+t.Time.Format("2006-01-02 15:04:05")+`"`)
		} else {
			io.WriteString(w, "null")
		}
	})
}

func UnmarshalNullTime(v interface{}) (mysql.NullTime, error) {
	nt := mysql.NullTime{}
	if str, ok := v.(string); ok {
		t, err := UnmarshalDatetime(str)
		if err == nil {
			nt.Time = t
			nt.Valid = true
		}
		return nt, err
	}
	return nt, errors.New("time should be a unix timestamp")
}

func MarshalMap(t map[string]interface{}) graphql.Marshaler {
	return graphql.WriterFunc(func(w io.Writer) {
		if bytes, err := json.Marshal(t); err == nil {
			w.Write(bytes)
		} else {
			io.WriteString(w, "null")
		}
	})
}

func UnmarshalMap(v interface{}) (map[string]interface{}, error) {
	var nt map[string]interface{}
	if str, ok := v.(string); ok {
		err := json.Unmarshal([]byte(str), &nt)
		return nt, err
	}
	return nt, errors.New("map should be string")
}

func UnmarshalPoint(v interface{}) (geo.Point, error) {
	point := geo.Point{}
	if v == nil {
		return point, nil
	}
	if value, ok := v.([]interface{}); ok {
		if len(value) != 2 {
			return point, errors.New("invalid location")
		}
		point.SetLat(value[0].(float64))
		point.SetLng(value[1].(float64))
		return point, nil
	}
	return point, errors.New("value is not location")
}

func MarshalPnit(v geo.Point) graphql.Marshaler {
	return graphql.WriterFunc(func(w io.Writer) {
		io.WriteString(w, fmt.Sprintf("[%f, %f]", v.Lat(), v.Lng()))
	})
}

type FilterType string

const (
	Eq   FilterType = "eq"
	Neq             = "neq"
	Gt              = "gt"
	Gte             = "gte"
	Lt              = "lt"
	Lte             = "lte"
	Like            = "like"
	Between         = "between"
)

type FilterOnField []map[FilterType]interface{}

// TODO: optimize
func (f *FilterOnField) UnmarshalGQL(v interface{}) error {
	var err error
	vjson, _ := json.Marshal(v)
	if json.Unmarshal(vjson, f) == nil {
        return nil
    }
	singleMap := map[FilterType]interface{}{}
	err = json.Unmarshal(vjson, singleMap)
	if err == nil {
        *f = []map[FilterType]interface{}{
            singleMap,
        }
        return nil
	}
	*f = []map[FilterType]interface{}{
	    {Eq: v},
	}
	return nil
}

func (f FilterOnField) MarshalGQL(w io.Writer) {
	data, err := json.Marshal(f)
	if err != nil {
		w.Write([]byte(`null`))
	} else {
		w.Write([]byte(`"` + string(data) + `"`))
	}
}

func (f *FilterOnField) Hash() (string, error) {
	if f == nil {
		return "", nil
	}
	var arr []string
	for _, _f := range *f {
		filterTypes := []FilterType{Eq, Neq, Gt, Gte, Lt, Lte, Like, Between}

		for _, ft := range filterTypes {
			value := _f[ft]
			arr = append(arr, fmt.Sprintf("%s -> %v", ft, value))
		}
	}
	sort.Strings(arr)

	h := md5.New()
	for _, item := range arr {
		_, err := io.WriteString(h, item)
		if err != nil {
			return "", err
		}
	}
	return fmt.Sprintf("%x", h.Sum(nil)), nil
}
