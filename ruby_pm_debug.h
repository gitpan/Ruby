/* $Id: plrb_debug.h,v 1.3 2004/04/11 05:04:46 jigoro Exp $ */

#ifndef RUBY_PM_DEBUG_H
#define RUBY_PM_DEBUG_H

enum debug_flag
{
	DB_INITFINAL = 0x0001,
	DB_INSTALL   = 0x0002,
	DB_VALUE2SV  = 0x0004,
	DB_SV2VALUE  = 0x0008,
	DB_FUNCALL   = 0x0010,
	DB_EVAL      = 0x0020,
	DB_GVAR      = 0x0040,
	DB_METHOD    = 0x0080,
	DB_NODE      = 0x0100,

};


#ifdef RUBY_PM_DEBUG
	#define D(flag, list)  do{dTHX;if(SvIV(get_sv("Ruby::DEBUG", FALSE)) & flag) warn list;}while(0)
	#define D_STMT(stmt) stmt

	#define PerlAssert(test) (test ? NOOP :\
			croak("Assertion failed (%s) at %s line %d\n", #test, __FILE__, __LINE__))

	#define PerlAssertIntEQ(l,r) (l == r ? NOOP :\
			croak("Assertion failed (%s:%ld == %s) at %s line %d\n", #l, (long)l, #r, __FILE__, __LINE__))
	#define PerlAssertIntNE(l,r) (l != r ? NOOP :\
			croak("Assertion failed (%s:%ld != %s) at %s line %d\n", #l, (long)l, #r, __FILE__, __LINE__))
	#define PerlAssertStrEQ(l,r) (strEQ(l,r) ? NOOP :\
			croak("Assertion failed (%s:%s == %s) at %s line %d\n", #l, (char*)l, #r, __FILE__, __LINE__))
	#define PerlAssertStrNE(l,r) (strNE(l,r) ? NOOP :\
			croak("Assertion failed (%s:%s != %s) at %s line %d\n", #l, (char*)l, #r, __FILE__, __LINE__))


	#define RubyAssert(test) (test ? NOOP : rb_raise(rb_eException, "Assertion failed (%s) at %s line %d\n", #test, __FILE__, __LINE__))

	#define RubyAssertIntEQ(l,r) (l == r ? NOOP : rb_raise(rb_eException, "Assertion failed (%s:%ld == %s) at %s line %d\n", #l, (long)l, #r, __FILE__, __LINE__))
	#define RubyAssertIntNE(l,r) (l != r ? NOOP : rb_raise(rb_eException, "Assertion failed (%s:%ld == %s) at %s line %d\n", #l, (long)l, #r, __FILE__, __LINE__))

	#define RubyAssertStrEQ(l,r) (strEQ(l,r) ? NOOP : rb_raise(rb_eException, "Assertion failed (%s:%s == %s) at %s line %d\n", #l, (char*)l, #r, __FILE__, __LINE__))
	#define RubyAssertStrNE(l,r) (strNE(l,r) ? NOOP : rb_raise(rb_eException, "Assertion failed (%s:%s == %s) at %s line %d\n", #l, (char*)l, #r, __FILE__, __LINE__))
	
#else
	#define D(flag, list)    NOOP
	#define D_STMT(stmt)

	#define PerlAssert(test) NOOP
	#define PerlAssertIntEQ(l,r) NOOP
	#define PerlAssertIntNE(l,r) NOOP
	#define PerlAssertStrEQ(l,r) NOOP
	#define PerlAssertStrNE(l,r) NOOP
	#define RubyAssert(test) NOOP
	#define RubyAssertIntEQ(l,r) NOOP
	#define RubyAssertIntNE(l,r) NOOP
	#define RubyAssertStrEQ(l,r) NOOP
	#define RubyAssertStrNE(l,r) NOOP
#endif

#endif /* RUBY_PM_DEBUG_H */
