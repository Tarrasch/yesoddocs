-- START
{-# LANGUAGE QuasiQuotes, TypeFamilies, GeneralizedNewtypeDeriving, TemplateHaskell, OverloadedStrings #-}
import Database.Persist
import Database.Persist.Sqlite
import Database.Persist.TH
import Data.Time
import Control.Monad.IO.Class (liftIO)

share [mkPersist, mkMigrate "migrateAll"] [$persist|
Person
    name String Eq
    age Int Gt
|]

main = withSqliteConn ":memory:" $ runSqlConn $ do
    runMigration migrateAll
    michaels <- selectList
        [ PersonNameEq "Michael"
        , PersonAgeGt 25
        ]
        [] 0 0 -- we will explain these later, all in good time
    liftIO $ print michaels
-- STOP
