#lang scribble/manual

@title{A Recursive Introduction}

By Allan Schougaard, San Diego Mesa College.

This work is release into the public domain.

This is a gentle introduction to the concept and use of recursion.
Starting with simple ideas and ending in deeply recursive images.

@bold{Table of Contents}
@table-of-contents[]
@section{Recursion: A Magic Superpower}
"In order to understand recursion, you have to understand recursion..."
             
@italic{--Anybody who has ever worked with recursion}

@subsection{Magic?}

Consider the following program:

@codeblock{
(define (count-down numb)
  (if (= numb 0)
      "Lift-off!"
      (string-append (number->string numb) " " (count-down (- numb 1)))
  )
)  
}

@italic{There are language constructs in the program that you may not have learned yet,
 but see if you can get an intuitive idea of what the program does.}

👉 What do you think @code{(count-down 10)} will return? Does the program even run?

What may have caught your attention is that inside of the definition of @code{count-down}
is a call to @code{count-down} itself.

On one hand, why should it be a problem? it is just like any other call to a function.
On the other hand, how can you use a function to define itself?
In other academic departments you may have heard that "you cannot define a term in terms of itself."

But - are we? @italic{really}?

Let us look a little closer. The call:

@codeblock{(count-down 10)}

evaluates to (simplified):

@codeblock{
  (if ...
      ...
      (string-append ... (count-down (- 10 1)))
  )
}

which evaluates to:

@codeblock{
  (if ...
      ...
      (string-append ... (count-down 9))
  )
}

so what is really happening is that @code{(count-down 10)} is defined in terms of @code{(count-down 9)}
which is not the same thing.

There is only one issue left: If we keep going then @code{(count-down 10)} is defined in terms of @code{(count-down 9)}
which is defined in terms of @code{(count-down 8)} which is defined in terms of @code{(count-down 7)} which is defined in terms of @code{(count-down 6)}...

The issue is that the recursion (the count down) has to stop at some point, otherwise it will continue forever, and we would have created an infinite loop.
The solution is to have a stop criteria, what is know as a base case.
In this example, the program stops when the number is 0.

So the elements of creating a recursive function are:

@itemlist[#:style 'unordered
          @item{Find a simple case where the recursion can stop. We call this the base case.}
          @item{State the problem is terms of smaller problems, a strategy known as "divide-and-conquer."}
          @item{Believe that the function works for smaller problems, also known as leap-of-faith.}
         ]

In practice, you do not have to belive in magic for recursion to work;
you can work it out by going through all the evaluations.

@subsection{Seeing Recursion}
Let us explore what recursion can look like in pictures.
What we are going to do is place increasingly smaller pictures on top of each others,
similar to a Matryoshka or nesting doll; see @url{https://en.wikipedia.org/wiki/Matryoshka_doll}.

@image[#:scale 0.5]{img/640px-Floral_matryoshka_set_2_smallest_doll_nested.jpg}
(BrokenSphere; Wikipidea)

We will start by "nesting" squares:
@codeblock{
(define (nest iterations)
  (if (= iterations 1)
      (square (* iterations 25) "solid" "orange")
      (above ; composition
       (nest (- iterations 1))
       (square (* iterations 25) "outline" "black")
      )
  )
)
}

👉 What does @code{(nest 5)} produce? Can you tell when the base case is evaluated?

Maybe that does not really look like nesting?

👉 Replace the composition with @code{beside}. Does that look like nesting?

👉 Try @code{overlay}.

👉 Try @code{(overlay/align "left" "top" ... ...)}.

👉 What happens if you use @code{(overlay (rotate 15 ...) ...)}?

👉 What if you switch them around: @code{(rotate 15 (overlay ... ...))}?



@section{Recursion on Numbers}

Whole numbers, also known as integers, naturally lends themselves to recursion.
(Maybe that is why they are also called natural numbers?)

To help us along us along, here are some templates that we can use for recursion on numbers:

@codeblock{
(define (func numb)
  (if (= 0 numb)              ; stopping condition
      ...                     ; base case
      (... (func (- numb 1))) ; recursive case
  )
)
}

or:

@codeblock{
(define (func numb)
  (cond
    ((= numb 0) ...)               ; base cases
    ((= numb 1) ...)
    (else (... (func (- numb 1)))) ; recursive case
  )
)
}

@subsection{Factorial}

Factorial is a function that is used in statistics to calcalate how many different ways you can select elements from a collection;
see: @url{https://en.wikipedia.org/wiki/Factorial}.

Many of the definitions of factorial look like this:
@codeblock{
n! = n x (n-1) x (n-2) x ... x 2 x 1
}

This is a @italic{declarative} definition, or a @italic{what-is} defintion,
but it does not really tell us how to calculate factorial. What does the text even mean?

@codeblock{
5! = 5 x (5-1) x (5-2) x ... x 2 x 1 = 120 ?
2! = 2 x (2-1) x (2-2) x ... x 2 x 1 = 0 ?
}

What do the ellipsis actually mean? How am I to interpret this?
It may be fine for humans (and mathematicians) because we are superb at finding meaning in everything
(even when there is none).
But for a computer we need another kind of definition, one that describes @italic{how to} calculate the function.
In other words we need an @italic{imperative} definition.

Here is an imperative or how-to definition:
@codeblock{
0! = 1
n! = n x (n-1)!, if n>0
}

Let us calculate 2!:

@codeblock{
2! = 2 x (2-1)! = 2 x 1! =
     2 x (1 x (1 - 1)!) =
     2 x 1 x 0! =
     2 x 1 x 1 = 6
}

👉 Can you tell where each of the rules of the definition is being used?

You might have noticed that the how-to definition is recursive?
And we can translate it into a Lisp function:
@codeblock{
(define (factorial numb)
  (if (= 0 numb)
      1
      (* numb (factorial (- numb 1)))
  )
)
}

👉 Test the function: Does it work for 3? does it work for -3? Try calcuating for 10,000

@subsection{Fibonacci Numbers}

The Fibonacci numbers originates out of trying to calculate
how many rabbits come out of a single pair after a given number of generations,
but is found many places in nature and is related to the golden ratio;
see @url{https://www.imaginationstationtoledo.org/about/blog/the-fibonacci-sequence} and
@url{https://www.youtube.com/watch?v=SjSHVDfXHQ4} (they are a little magical).

The how-to definition is:
@codeblock{
fibonacci(0) = 0
fibonacci(1) = 1
fibonacci(n) = fibonacci(n-1) + fibinacci(n-2) if n>1
}

The complication is that the base case consists of two rules,
but we have seen something similar in the backwards String example.
We could do this with nested @code{if}-expressions, but it is easier to use a @code{cond}:
@codeblock{
(define (fibonacci numb)
  (cond
    ((= numb 0) 0)
    ((= numb 1) 1)
    (else (+ (fibonacci (- numb 1)) (fibonacci (- numb 2))))
  )
)
}

👉 Try finding the Fibonacci number for 3? and 30? 35?


@subsection{Compound Interest}
Compound interest is what banks use to calculate how much they are going to pay you to lend your money,
or how much you have to pay to lend their money.

Let us look at an example: If you deposit $100 into a bank account at the beginning of a year
and the account carries a 10% interest rate, then at the end of the year the bank will pay you
$10 which means you have $110 in your account at the end of the year. If we leave the money in the account,
then at the start of the next year we have $110 in our account, and the bank will give us 10% for our service.
But since we have $110, 10% is now $11, which means that at the end of that year, we have $121.
And so on. Sometimes this is called "interest on interest."
See @url{https://www.investopedia.com/terms/c/compoundinterest.asp}.

Let us see how we can use recursion to calculate compound interest:
If we have $100 in the account at the beginning of the year, then we have $100 when no periods have passed.
So:

@codeblock{
(define (calculate-end-balance start-balance periods interest-rate)
  (if (= periods 0)
      start-balance
      ...
  )
)
}

After the first year we receive some interest which is added to the balance:

@codeblock{
ending-balance = starting-balance + starting-balance x interest-rate/100
}

Let us make that a little simpler:

@codeblock{
ending-balance = starting-balance x (1 + interest-rate/100)
}

Translated into Lisp:

@codeblock{
(define (calculate-end-balance start-balance periods interest-rate)
  (if (= periods 0)
      start-balance
      (* start-balance (+ 1 (/ interest-rate 100)))
  )
)
}

This only works for the first year.

Here is the corner-stone of this case:
The starting balance of a year is the ending balance of the prevous year.
The previous year starts at: @code{periods - 1}.
So we can calculate the new start balance with a leap-of-faith:

@codeblock{
(calculate-end-balance start-balance (- periods 1) interest-rate)
}

All in all, we have:

@codeblock{
(define (calculate-end-balance start-balance periods interest-rate)
  (if (= periods 0)
      start-balance
      (* (calculate-end-balance start-balance (- periods 1) interest-rate)
         (+ 1 (/ interest-rate 100))
      )
  )
)
}

👉 Test the function: Does it work for all of the examples we calculated above?

👉 How long does it take to double your money with 10% interest rate?

@section{Recursion with Images}

To use recursion with images we have to use different operators than with numbers.
With numbers we have used + and *, but with images we have to use combinators,
such as @code{above}, @code{beside}, @code{overlay}, etc.

@subsection{Modern Art: Recursive Mondrian}
Piet Mondrian is famous for making abstract paintings with with only rectangles; see:
@url{https://www.theartlifegallery.com/blog/the-enduring-legacy-of-piet-mondrians-abstract-paintings/} and
@url{https://shop.tate.org.uk/piet-mondrian-no.-vi-composition-no.ii/piemon005.html}.

We are going to make something similar by recursively placing rectangles beside and above/below each other.
Eventually we may get something similar to:

@image{img/RecursiveMondrianExample.png}

First we need a function that can give us the colors we want to work with based on a number,
so that we can color the rectangles differently as we move through the iterations:

@codeblock{
(define (get-color numb)
  (cond
    ((= 0 numb) "blue")
    ((= 1 numb) "red")
    ((= 2 numb) "yellow")
    (else "white")
  )
)
}

Then we need a function that can create the building blocks of the picture:

@codeblock{
(define border-width 5)

(define (mondrian-box width height)
  (overlay
   (rectangle (- width border-width) (- height border-width) "solid" (get-color (random 4)))
   (rectangle width height "solid" "black") ; black frame
   )
)
}

The idea we are going to use is that we will start with a rectangle of given dimensions and
subdivide it a given number of times. Here is a template:

@codeblock{
(define (mondrian iterations width height)
  (cond
    ((<= iterations 0) (mondrian-box width height))
    (else
      (beside (mondrian ... ... ...)
              (mondrian ... ... ...)
      )
    )
  )
)
}

Since we are placing mondrians next to each other, we can halve the width of each to fit into
the original dimensions:

@codeblock{
(define (mondrian iterations width height)
  (cond
    ((= iterations 0) (mondrian-box width height))
    (else
      (beside (mondrian (- iterations 1) (/ width 2) height)
              (mondrian (- iterations 1) (/ width 2) height)
      )
    )
  )
)
}

👉 Try: @code{(mondrian 3 300 300)} and @code{(mondrian 5 300 300)}

We are not quite there, somehow we have to subdivide horizontally some of the time.
We can use the @code{random} function for that:

@codeblock{
(define (mondrian iterations width height)
  (cond
    ((= iterations 0) (mondrian-box width height))
    ((= (random 2) 0)
     ...
    )
    (else
      (beside (mondrian (- iterations 1) (/ width 2) height)
              (mondrian (- iterations 1) (/ width 2) height)
      )
    )
  )
)
}

To subdivide horizontally we can use @code{above},
but now we have to decrease the height in order to stay within the given dimensions.

@codeblock{
(define (mondrian iterations width height)
  (cond
    ((= iterations 0) (mondrian-box width height))
    ((= (random 2) 0)
      (above (mondrian (- iterations 1) width (/ height 2))
             (mondrian (- iterations 1) width (/ height 2))
      )
    )
    (else
      (beside (mondrian (- iterations 1) (/ width 2) height)
              (mondrian (- iterations 1) (/ width 2) height)
      )
    )
  )
)
}

👉 Try: @code{(mondrian 3 300 300)} and @code{(mondrian 4 300 300)}

If we want to be really artistic the image has to have the Golden ratio:

@codeblock{
(define golden-ratio (/ (+ 1 (sqrt 5)) 2))
(mondrian 4 (* golden-ratio 400) 400)        
}

👉 Run the function many times until you find a picture you like.
Marvel in it because next time you run the program you will likely get something different.

👉 Try changing the colors.

👉 Try a different subdivision in one or both dimensions.

👉 Try varying the number of iterations in each subdivision, maybe randomly?

@subsubsection{Mondrians in the Real World}

The Mondrian structures are not just abstract art,
but used in many places in design, architecture, science and math.

Some uses in architecture (possibly):

@image[#:scale 0.5]{img/MondrianWindowsCrop.png}

(Creator: Robert Francis. @url{https://www.flickr.com/photos/robertfrancis/398440152})

@image[#:scale 0.5]{img/AlbertslundWindowsCrop.png}

(Creator: Allan Schougaard. Public domain.)

Some uses in chemistry:

Scientists create computer program that “paints” the structure of molecules in the style of Piet mondrian.
(2024, July 15). Trinity College Dublin. 
@url{https://www.tcd.ie/news_events/articles/2024/scientists-create-computer-program-that-paints-the-structure-of-molecules-in-the-style-of-piet-mondrian}

Computer program ‘paints’ porphyrin structures in the style of famous artist.
(2024, July 23). Chemistry World.
@url{https://www.chemistryworld.com/news/computer-program-paints-porphyrin-structures-in-the-style-of-famous-artist/4019839.article}

How about a Mondrian inspired theme for your computer:

Mondrian. (2020). KDE Store. @url{https://store.kde.org/p/1350981}

And on the humorous side:

Mondrian painting has been hanging upside down for 75 years. (2022, October 28). the Guardian.
@url{https://www.theguardian.com/artanddesign/2022/oct/28/mondrian-painting-has-been-hanging-upside-down-for-75-years}


@subsection{The Face of a Clock}

We are going to make a clockface.
That is an image with the numbers 1 through 12 placed around the edge at equidistant points with 12 at the top.

Let us start with creating the background on which the number are place. A nice circle should do:
@codeblock{
(define background (circle 200 "outline" "gray"))
}

We can take a hint from the description and find out how to place "12" at the top.
Since the numbers go inside the circle we can use @code{overlay}:
@codeblock{
(overlay/align "center" "top"
               (text "12" 36 "green")
               background
)
}

So we got 12 in place, and we now know how to place something at the top center of the clockface.
The question is now can we somehow use this to place all the other numbers?
Well, if we rotate the watch face so that the place for 1 is at the top, we can.
How much should we rotate?
There 360 degrees in a circle, and 12 hours on the watch face,
so 360/12 = ... Lisp can do the calculation for us.
Let us place 1 o'clock:
@codeblock{
(overlay/align "center" "top"
               (text "1" 36 "green")
               (rotate (/ 360 12)
                       (overlay/align "center" "top" ; same as before
                                      (text "12" 36 "green")
                                      background
                       )
               )
)
}

Now 12 is in the wrong place, but we can move on to 10, 9, etc. and eventually we will come full circle and 12 will be at the top again.
With that we are ready start writing a recursive function.
What should our stop condition be? Let us say that when we get to zero, we start with the background:
@codeblock{
(define (around-the-clock numb)
  (if (= numb 0)
      background
      ...
  )
)
}

For every other number, we rotate and place the number on a clockface that has on the previous numbers:
@codeblock{
(define (around-the-clock numb)
  (if (= numb 0)
      background
      (overlay/align "center" "top"
               (text (number->string numb) 36 "green")
               (rotate (/ 360 12) (around-the-clock (- numb 1)))
      )
  )
)
}

👉 Try @code{(around-the-clock 10)}. What do you think will happend? Did it?


@section{Recursive Fractals}

A fractal is a self-similar image; self-similar means that if you zoom in on it, what you see is similar to the original view.
So to construct a fractal, we compose elements out of increasingly bigger or smaller elements.

@subsection{The Sierpinski Triangle}

The Sierpinski triangle is triangle that is made out of other triangles. The base case is a simple triangle,
and the recursive case places a triangle on top of two other triangles, very similar to how we constructed the tower above:
@codeblock{
(define base-triangle (triangle 10 "solid" "tan"))
 
(define (sierpinski-triangle iterations)
  (if (= iterations 0)
      base-triangle
      (above (sierpinski-triangle (- iterations 1))
             (beside (sierpinski-triangle (- iterations 1)) (sierpinski-triangle (- iterations 1)))
      )
  )
)
}

👉 Try: @code{(sierpinski-triangle 1)}, @code{(sierpinski-triangle 2)}, @code{(sierpinski-triangle 3)}, @code{(sierpinski-triangle 7)}

👉 Do you recognize the pattern from somewhere you have been?

@subsection{The Sierpinski Carpet}

The Sierpinski carpet is square that is made out of other squares.
The squares are composed with:
@codeblock{
(above (beside square square  square)
       (beside square nothing square)
       (beside square square  square)
)
}

👉 Create a Sierpinski carpet. Do you recognize from somewhere you have been?

@subsection{Koch Snowflake}
The Koch Snowflake is a fractal that starts out as a triangle and the more and more "bumps" are added to each side.
See: @url{https://math.libretexts.org/Learning_Objects/Interactive_Calculus_Activities/Kochs_Snowflake}

We will start by making just one side and then later combine it to a full snowflake.
Side starts out as simple a line of a given length:
@codeblock{
(define (koch-curve side-length iterations)
  (if (= iterations 1)
      (rectangle side-length 1 "solid" "black")
      ...
  )
)
}

Then it the next iteration, we divide the line into three parts:
@itemlist[#:style 'unordered
          @item{The first part is a line of 1/3 the length of the original line.}
          @item{The middle part is two of this sides of an equilateral triangle.
                (In equilateral triangles all the angles are 60°)
                The sides are 1/3 of the length of the original line.
          }
          @item{The last part is a line of 1/3 the length of the original line.}
]

So we have to combine:
@codeblock{
(koch-curve (/ side-length 3) ...) ; first 1/3
(rotate 60 (koch-curve (/ side-length 3) ...)) (rotate -60 (koch-curve (/ side-length 3) ...)) ; second 1/3
(koch-curve (/ side-length 3) ...) ; last 1/3
}

Since we are constructing a image essentially on a line, we can use @code{beside}
but it has to align with the bottom. So we have:
@codeblock{
(define (koch-curve side-length iterations)
  (if (= iterations 1)
      (rectangle side-length 1 "solid" "black")
      (beside/align "bottom"
                    (koch-curve (/ side-length 3) (- iterations 1)) ; first 1/3
                    (rotate 60 (koch-curve (/ side-length 3) (- iterations 1))) ; second 1/3
                    (rotate -60 (koch-curve (/ side-length 3) (- iterations 1)))
                    (koch-curve (/ side-length 3) (- iterations 1)) ; last 1/3
       )
  )
)
}

👉 Try: @code{(koch-curve 200 1)}, @code{(koch-curve 200 2)}, @code{(koch-curve 200 3)}, @code{(koch-curve 200 4)}, @code{(koch-curve 200 7)} 
(Note: Due the way @code{beside} works, the length of each side increases by a few pixes for each iteration.
This is not the intended behavior.)


@subsection{Lindermayer Systems}

Finally, we are going to explorer how to build plants that look almost nature.
This is part of a bigger topic of Lindermayer systems; see: @url{https://en.wikipedia.org/wiki/L-system},
@url{https://paulbourke.net/fractals/lsys}, and @url{http://algorithmicbotany.org/}.

@subsubsection{A Single Straw}

We can make a single straw by recursively add smaller straws onto a base straw:

@codeblock{
(define trunk (rectangle 5 100 "solid" "brown")) ; the repeated primitive
(define scale-factor 0.75)                       ; reduce size with each iteration
(define split-angle 10)                          ; turn the offspring a little
(define y-offset (* 2 (image-height trunk)))     ; place the offspring at the end of the previous image

(define (make-straw iterations)
  (if (= iterations 0)
      trunk
      (overlay/align/offset "right" "top"
                            (rotate split-angle
                                    (scale scale-factor
                                           (make-straw (- iterations 1))
                                    )
                            )
                            0 y-offset
                            trunk
      )
  )
)


(make-straw 5)
(make-straw 10)
           
}

@subsubsection{Simple Plants}
For our first plant we are going to do something simple: we start with a single vertical line and
on top of it we put two smaller versions of the line at a split-angle with each other.

@codeblock{
(define trunk (rectangle 5 50 "solid" "brown"))
(define scale-factor 0.60)
(define split-angle 40)

(above
 (scale scale-factor
        (beside (rotate split-angle trunk) (rotate (- split-angle) trunk))
 )
 trunk
)
}

Next we turn the scaled trunks into full trees on their own by using recursion:
@codeblock{
(define (make-simple-tree iterations)
  (if (= 0 iterations)
      trunk
      (above
       (scale scale-factor
              (beside (rotate split-angle (make-simple-tree (- iterations 1)))
                      (rotate (- split-angle) (make-simple-tree (- iterations 1))))
       )
       trunk
       )
   )
)
}

👉 With that you can make your own trees; try: @code{(make-simple-tree 5)} or @code{(make-simple-tree 7)}.

👉 Try varying the trunk of the tree, scale-factor and split-angle to see what you can make;
do not be surprised if the tree falls completely apart,
finding the right parameters is part of the process.

To have green leaves, we can use:
@codeblock{
(define leaf (circle 15 "solid" "green"))

(define (make-simple-tree iterations)
  (if (= 0 iterations)
      leaf ; the base case will make up the leaves
      (above
       (scale scale-factor
              (beside (rotate split-angle (make-simple-tree (- iterations 1)))
                      (rotate (- split-angle) (make-simple-tree (- iterations 1))))
       )
       trunk
       )
   )
)
}

@section{Advanced Problem-Solving}

@subsection{An Example on String}

Let us use our knowledge of recursion to see how we can solve a problem using a String.
We would like to make a function that reverses a String, meaning spell a word backwards:
@codeblock{
(backwards "He") -> "eH"
(backwards "Racecar") -> "racecaR"
}

Let us start by making some observations: What are the simplest examples we can come up with? Well, the shorter the String, the less work we have to do. So:
@codeblock{
(backwards "a") -> "a"
(backwards "z") -> "z"
}

Can we create somethig shorter? Yes, the "empty String":
@codeblock{
(backwards "") -> ""
}

In all of these cases, the return value is the same as the input value,
so we do not need to do any processing.
We can program that directly:
@codeblock{
(define (backwards word)
  word
)
}

This only works for String of length 0 or 1.
When we include the condition for when we can use this simple implementation, we have:
@codeblock{
(define (backwards word)
  (if (<= (string-length word) 1)
          word
          ...
  )
)
}
Let us look at something a little more involved: What if the word has two characters?

@codeblock{
(backwards "ab") -> "ba"
}

The observation to make here is that the first letter becomes the last letter,
and the last letter becomes the first letter.
We can implement that with:

@codeblock{
(define (backwards word)
  (if (<= (string-length word) 1)
          word
          (string-append
              (string-ith word 1) ; last letter
              (string-ith word 0) ; first letter
          )
  )
)
}

Now we have to look at longer Strings. Let us look at three letters:

@codeblock{
(backwards "abc") -> "cba"
}

It is still true that the first letter becomes the last, and the last letter becomes the first.
Our current implementation returns:

@codeblock{
(backwards "abc") -> "ba"
}

so we are loosing a letter (the last). Let us see if we can get it back:

@codeblock{
(define (backwards word)
  (if (<= (string-length word) 1)
          word
          (string-append (string-ith word 2) ; last letter
                         (substring word 0 2); first part of the word
          )
  )
)
}

which gives us:

@codeblock{
(backwards "abc") -> "cab"
}

Let us try that with a four letter word:
@codeblock{
(backwards "abcd") -> "cab"
}

The @code{"d"} is missing,
and that is because @code{(string-ith word 2)} is not the last letter in @code{"abcd"}.
The last letter has index @code{(- (string-length word) 1)}; one less that the length because
the indices start at 0.
So in our implementation, we replace @code{2} with the index of the last letter:
@codeblock{
(define (backwards word)
  (if (<= (string-length word) 1)
      word
      (string-append
       (string-ith word (- (string-length word) 1))   ; the last letter
       (substring word 0 (- (string-length word) 1))  ; all the letters before the last
      )
  )
)
}

which gives us:
@codeblock{
(backwards "abcd") -> "dabc"
}

All the letters are there, but the last letters are in the wrong order.

👉 What order are they in? What order do we want them in?

So all we have to do is reverse the last letters.
Do we have a function that can reverse letters? We do if we believe we do...

In this example, we can use @code{(backwards "abc")},
which in general is: @code{(backwards (substring word 0 (- (string-length word) 1)))}

Let us use it on the last letters:
@codeblock{
(define (backwards word)
  (if (<= (string-length word) 1)
      word
      (string-append
       (string-ith word (- (string-length word) 1))               ; the last letter
       (backwards (substring word 0 (- (string-length word) 1)))  ; reverse the letters before the last
      )
  )
)
}

👉 And now the function works on Strings of any length; try it for yourself.

There were two tricks we used to implement this function:

@itemlist[#:style 'unordered
          @item{Find the simplest or smallest examples and use them as starting point.
           This is known as the @italic{base case} and is used to stop the recursion.}
          @item{Find a way to break down the problem into smaller problems
           that we can call on the function to handle and then combine the results to a full solution.
          This is known as the @italic{recursive case}.}
]



@subsection{The Towers of Hanoi}
In this section we are going to look at a problem is that very difficult solve to without recursion,
but easy to solve with recursion.
At the end I hope that you will see that recusion really is a kind of magic superpower.

The problem we are going to look at is called the Towers of Hanoi:

The tower of Hanoi (also called the tower of Brahma or the Lucas tower)
was invented by a French mathematician Édouard Lucas in the 19th century.
It is associated with a legend of a Hindu temple where the puzzle was supposedly
used to increase the mental discipline of young priests.
In the legend the young priests were given 64 gold disks stacked neatly on one of three posts.
Each disk rested on a slightly larger disk.
The priests' goal was to re-create the stack on a different post by moving disks, one at a time,
to another post with the rule that a larger disk could never be placed on top of a smaller disk. 
(Science Buddies, Sabine De Brabandere. (2017, October 26). The Tower of Hanoi. Scientific American.
@url{https://www.scientificamerican.com/article/the-tower-of-hanoi})

There are four rules for moving the discs:
@itemlist[#:style 'unordered
          @item{Discs are moved one at a time.}
          @item{A disc can only be moved from the top of a pile.}
          @item{Any disc that can be moved, can be placed on an empty peg.}
          @item{Only a smaller disc can be placed on top of a bigger disc.}
         ]

👉 Start with one disc, can you solve how to move the disc to another peg?

Too easy? Go on...

👉 With two discs, can you solve how to move the pile to another peg?

👉 With three discs, can you solve how to move the pile to another peg?

For musical introduction see:
Numberphile. (2021, October 27). Key to the Tower of Hanoi - Numberphile [Video]. YouTube.
@url{https://www.youtube.com/watch?v=PGuRmqpr6Oo}.

For an animated introduction see:
Reducible. (2020, May 26). Towers of Hanoi: A Complete Recursive Visualization [Video]. YouTube.
@url{https://www.youtube.com/watch?v=rf6uf3jNjbo}

For a Khan introduction see:
Towers of Hanoi. (n.d.). Khan Academy.
@url{https://www.khanacademy.org/computing/computer-science/algorithms/towers-of-hanoi/a/towers-of-hanoi}

For a mathematical introduction see:
3Blue1Brown. (2016, November 25). Binary, Hanoi and Sierpinski, part 1 [Video]. YouTube.
@url{https://www.youtube.com/watch?v=2SUvWfNJSsM}

We are going to write a program that can move a pile of discs from one peg to another.
The program will tell us the moves we have to make in order to move a pile of discs
from one peg to another. We are going to call the pegs left to right: "A", "B", "C".

Let us start by solving the simplest problem we can:
Moving one disc from one peg to an empty peg or a peg with bigger discs.
All the program has to do is return the "move" instruction:

@codeblock{
; Purpose: Move one disc from one named peg to an empty named peg or a peg with bigger discs.
; So given the name of a peg and the name of an empty peg, create the instruction to move
; from the former peg to the latter peg.
; Signature: String String -> String
; Examples
; (move "A" "B") -> "Move a disc from A to B;"
; (move "A" "C") -> "Move a disc from A to B;"
(define (move from to)
  (string-append "Move a disc from " from " to " to "; " )
)
}

Now, what about two discs?
We have to first move one disc to another peg and then move a second disc to the destination peg,
and then finally move the first disc onto the destination disc.
So to solve this situation we need a source pig, and a destination peg, but also a helper peg.

@codeblock{
; Purpose: Move two disc from one named peg to an empty named peg or a peg with bigger discs.
; So given the name of a peg and the name of an empty peg, create the instructions to move
; from the former peg to the latter peg using a helper peg.
; Signature: String String String -> String
; Examples
; (move-two "A" "B" "C") -> "Move disc from A to B; Move disc from A to C; Move disc from B to C;"
(define (move-two from helper to)
  (string-append (move from helper) (move from to) (move helper to))
)
}

How can we now solve the general problem: given the size of a pile on a peg,
how can we move the discs to a destination peg, using a another peg on the way?

Let us start with the a simple case: if the pile only has one disc we can use @code{move}.

👉 There is actually a simpler case. Can you see what it is? (hint: simpler means smaller)

So we can start with a template, using recursion on the number of discs that have to be moved:

@codeblock{
(define (solve-hanoi number-discs from helper to)
  (if (= number-discs 1)
      (move from to)
      ...
  )
)
}

From your work with three discs, you might have noticed a pattern that the discs have to move in:
First we get @code{n-1} (smaller) discs out of the way, then we move the @code{n}th disc to the final destination,
and then we finally move the first @code{n-1} (smaller) discs to the destination.

To recap that in a more algorithmic way:
@itemlist[#:style 'ordered
          @item{Move @code{n-1} discs from the source to the helper peg.}
          @item{Move a disc from the source to the destination peg (directly).}
          @item{Move @code{n-1} discs from the helper to the destination peg.}
         ]

This we can directly translate into Lisp:

@codeblock{
(define (solve-hanoi number-discs from helper to)
  (if (= number-discs 1)
      ; base case
      (move from to)
      ; recursive case
      (string-append       
       (solve-hanoi (- number-discs 1) from to helper)
       (move from to)
       (solve-hanoi (- number-discs 1) helper from to)
      )
  )
)
}

👉 What does: @code{(solve-hanoi 1 "A" "B" "C")} tell you to do?

👉 What does: @code{(solve-hanoi 2 "A" "B" "C")} tell you to do?

👉 What does: @code{(solve-hanoi 4 "A" "B" "C")} tell you to do? Is it correct?
Check by carrying out the instructions manually.

👉 Can you simplify the function by using @code{(zero? number-discs)}?
What else has to change?


(Inspired by:
Computerphile. (2019, October 1). Recursion 'Super Power' (in Python) - Computerphile [Video]. YouTube.
@url{https://www.youtube.com/watch?v=8lhxIOAfDss})

@section{References}

H A., Sussman, G. J., & Sussman, J. (2007). Structure and interpretation of computer programs - 2nd edition. Justin Kelly. 

Olivas, A. (2024). Antoni-ooo/CISC-106-Honors-Project: An honors project I had made for my mesa college introduction to programming class in spring 2024 =). GitHub.
@url{https://github.com/antoni-ooo/CISC-106-Honors-Project}

Borner, M. (2024, April 8). Lambda screen: Fractals in pure lambda calculus. Text.
@url{https://text.marvinborner.de/2024-03-25-02.html}

2.2 image guide. (n.d.). Racket Documentation.
@url{https://docs.racket-lang.org/teachpack/2htdpimage-guide.html}

Beauty and joy of computing. (n.d.). The Beauty and Joy of Computing.
@url{https://bjc.edc.org/bjc-r/topic/topic.html?topic=nyc_bjc/7-recursion-trees-fractals.topic&course=bjc4nyc.html}

Ho, N. (2023, January 1). An approach to sound synthesis with L-systems. Nathan Ho.
@url{https://nathan.ho.name/posts/sound-synthesis-with-l-systems/}

Heap, D. (2012, June 8). racket recursion video 1/6 --- triangle recursion [Video]. YouTube.
@url{https://www.youtube.com/watch?v=gZAXE1GWSF0}

@section{Appendix A: Other Great Ideas}

@subsection{Logistic Growth}
@url{https://en.wikipedia.org/wiki/Logistic_function}
@url{https://math.libretexts.org/Bookshelves/Applied_Mathematics/Math_in_Society_(Lippman)/08%3A_Growth_Models/8.06%3A_Logistic_Growth}

@subsection{Advanced Mondrian}

@codeblock{
(define (mondrian numb width height)
  (cond
    ((<= numb 0) (mondrian-box width height))
    ((= (random 2) 0)
      (above (mondrian (- numb 1)         width (/ height 2))
             (mondrian (floor (/ numb 2)) width (/ height 2))
             )
      )
    (else
      (beside (mondrian (floor (/ numb 2)) (/ width 2) height)
              (mondrian (- numb 1)         (/ width 2) height)
              )
     )
    )
)
}

@codeblock{
(define golden-ratio (/ (+ 1 (sqrt 5)) 2))
(define (mondrian iterations width height)
  (cond
    ((= iterations 0) (mondrian-box width height))
    ((= (random 2) 0)
      (above (mondrian (- iterations 1) width (* height (/ 1 golden-ratio)))
             (mondrian (- iterations 1) width (* height (- 1 (/ 1 golden-ratio))))
      )
    )
    (else
      (beside (mondrian (- iterations 1) (* width (/ 1 golden-ratio)) height)
              (mondrian (- iterations 1) (* width (- 1 (/ 1 golden-ratio))) height)
      )
    )
  )
)
}

@subsection{The Collatz Conjecture}
Wikipedia contributors. (2024, July 28). Collatz conjecture. In Wikipedia, The Free Encyclopedia.
Retrieved 18:24, August 12, 2024, from @url{https://en.wikipedia.org/w/index.php?title=Collatz_conjecture&oldid=1237098889}