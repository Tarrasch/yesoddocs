This example shows how generalized hamlet templates allow the creation of
different types of values. The key component here is the HamletValue typeclass.
Yesod has instances for:

* Html

* Hamlet url (= (url -> [(String, String)] -> String) -> Html)

* GWidget s m ()

This example uses all three. You are of course free in your own code to make
your own instances.

> {-# LANGUAGE QuasiQuotes, TypeFamilies #-}
> import Yesod
> data NewHamlet = NewHamlet
> mkYesod "NewHamlet" [$parseRoutes|/ RootR GET|]
> instance Yesod NewHamlet where approot _ = ""
> 
> myHtml :: Html
> myHtml = [$hamlet|%p Just don't use any URLs in here!|]
>
> myInnerWidget :: Widget NewHamlet ()
> myInnerWidget = do
>     addBody [$hamlet|
>   #inner Inner widget
>   $myHtml$
> |]
>     addStyle [$cassius|
>#inner
>     color: red|]
> 
> myPlainTemplate :: Hamlet NewHamletRoute
> myPlainTemplate = [$hamlet|
> %p
>     %a!href=@RootR@ Link to home
> |]
> 
> myWidget :: Widget NewHamlet ()
> myWidget = [$hamlet|
>     %h1 Embed another widget
>     ^myInnerWidget^
>     %h1 Embed a Hamlet
>     ^addBody.myPlainTemplate^
> |]
> 
> getRootR :: GHandler NewHamlet NewHamlet RepHtml
> getRootR = defaultLayout myWidget
> 
> main :: IO ()
> main = basicHandler 3000 NewHamlet
