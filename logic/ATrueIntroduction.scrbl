#lang scribble/manual

@title{A True Introduciton}

By Allan Schougaard, San Diego Mesa College.

This work is release into the public domain.

This is an intuitive introduction to the concept and use of boolean logic.

@bold{Table of Contents}
@table-of-contents[]

@section{True or False - that is the question}

In mathematics you may have seen expressions such as:

@codeblock{
1 < 2
}

which is read as: 1 is less than 2. You probably also intuitively know that this statement is true.
We are going to use this intution to build up a system of true and false.

Let us look at some more expressions and how they are written in LISP:

@itemlist[#:style 'unordered
          @item{1 < 2, @code{(< 1 2)} which is true}
          @item{1 > 2, @code{(> 1 2)} which is false}
          @item{1 = 1, @code{(= 1 1)} which is true}
          @item{1 = 2, @code{(= 1 2)} which is false}
         ]

👉 You can type the LISP expression directly into the intractions area of Dr. Racket and see that it "understands" the expressions.

Notice that all of the expressions evaluates to one of two values: true or false.
Compare that to @code{+} where you can get many different values. @code{+} adds elements of the datatype Numbers and returns Numbers,
while <, > and = compares Numbers, but returns true or false only.
True and false belong to the datatype called Booleans, which only contains these two values.
Booleans are named after George Bool, see: @url{https://en.wikipedia.org/wiki/George_Boole}.

@subsection{Introducing Or}

You may also have seen expression such as:

@codeblock{
1 ≤ 2
}

which is read as: 1 is less than or equal to 2.
You probaly also intuitively know as long as 1 is less than 2 or 1 is equal to 2, the expression is true.
We can also do this in LISP:

@itemlist[#:style 'unordered
          @item{1 ≤ 2, @code{(<= 1 2)} which is true}
          @item{1 ≥ 2, @code{(>= 1 2)} which is false}
          @item{1 ≤ 1, @code{(<= 1 1)} which is true}
          @item{1 ≥ 1, @code{(>= 1 1)} which is true}
         ]

Note that for 1 ≤ 2: 1 is less than 2 is true, but 1 is equal to 2 is false.
However since we are saying "or" only one of them have to be true.

In LISP we can use the @code{or} function:

@code{(<= 1 2)} is equivalent to: @code{(or (< 1 2) (= 1 2))}.

When this expression is evaluated, this is what happens:

@codeblock{
(or (< 1 2) (= 1 2)) ↦ (or true (= 1 2)) ↦ (or true false) ↦ true
}

so @code{or} is a function that returns true of @italic{any} of the input arguments are true.
What about if all the input arguments are false?
Let us look at an example again:

1 ≥ 2, which is false, is equivalent to: @code{(or (> 1 2) (= 1 2))} which evaluates like this:

@codeblock{
(or (> 1 2) (= 1 2)) ↦ (or false (= 1 2)) ↦ (or false false) ↦ false
}

So @code{or} is a function that takes in Booleans and returns a Boolean.

@subsection{Introducing And}

You might wonder since the @code{or} function only requires one argument to be true to return true,
in there a function that requires all input arguments to be true to return true.
The answer is: yes - it is called @code{and}.

An example: the fire triangle says that you need three things to have a compustion: Oxygen, heat and fuel.
If you only have two nothing will burn.
Assuming that we have the constants we can express this as:

@codeblock{
(and have-oxygen have-heat have-fule)
}

and only if all three have-s are true will we have combustion.

Let us look an example with numbers:

@codeblock{
(and (< 1 2) (= 1 2)) ↦ (and true (= 1 2)) ↦ (and true false) ↦ false
}

You can think of it as: "this must be true @italic{and} that must be true" for @code{and} to return true;
otherwise it returns false.


So @code{and} is a function that takes in Booleans and returns a Boolean.


@subsection{Introducing Not}

Sometimes we also need to say that something is not equal to something else.
Think about a traffic light: we only want to cross if the light is not red.
We can use the function @code{not}, so assuming the light is green we get:

@codeblock{
(not (= color-of-traffic-light red)) ↦ (not false) ↦ true
}

so we want to cross.
@code{not} reverses or inverts logic: if something is true, @code{not} makes it false;
and if something is false, @code{not} make it true.

@subsection{And Or Not - An Algebra}

Let us put everything together and extend the traffic light example:
We do @italic{not} want to cross if the light is yellow @italic{or} red.

This can be expressed as:

@codeblock{
(not (or (= color-of-traffic-light red) (= color-of-traffic-light yellow)))
}

Let us see if we should cross if the light is yellow:

@codeblock{
(not (or (= color-of-traffic-light red) (= color-of-traffic-light yellow))) ↦
(not (or false true)) ↦
(not true) ↦ false
}

so that would not be a good idea.



@section{References}

2.2 image guide. (n.d.). Racket Documentation.
@url{https://docs.racket-lang.org/teachpack/2htdpimage-guide.html}

@section{Appendix A: Other Great Ideas}

