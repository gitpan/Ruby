
#include "ruby_pm.h"

VALUE
rb_ivar_get_defaultv(VALUE obj, ID key, VALUE defaultvalue)
{
	VALUE val = rb_attr_get(obj, key);

	if(NIL_P(val)){
		val = defaultvalue;
		rb_ivar_set(obj, key, val);
	}
	return val;
}

VALUE
rb_ivar_get_defaultf(VALUE obj, ID key, defaultf_t defaultfunc)
{
	VALUE val = rb_attr_get(obj, key);
	if(NIL_P(val)){
		val = defaultfunc();
		rb_ivar_set(obj, key, val);
	}
	return val;
}

VALUE
plrb_str_new_sv(pTHX_ SV* sv)
{
	STRLEN len;
	const char* pv = SvPV(sv, len);
	VALUE result =  rb_str_new(pv, len);
	S2V_INFECT(sv, result);
	return result;
}
