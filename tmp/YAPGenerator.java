<?php

class YAPGenerator {

    private static $capitalLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    private static $lowercaseLetters = "abcdefghijklmnopqrstuvwxyz";
    private static $capitalHex = 'ABCDEF';
    private static $lowercaseHex = 'abcdef';
    private static $number = "0123456789";
    private static $symbols = ",.'\"/:;&!@#%*";

    public static function generatePasswords($numberOfPasswords = 10, $params = array() ) {
        $passwords = array();

        if ( !is_array($params) || empty($params) ) {
            return $passwords;
        }

        $chars = '';

        if ( $params["includeLetters"] ) {
            if ( $params['useHex'] ) {
                $chars .= self::$lowercaseHex;
            }
            else {
                $chars .= self::$lowercaseLetters;
            }
        }
        if ( $params["includeNumbers"] ) {
            $chars .= self::$number;
        }
        if ( $params["includeSymbols"] ) {
            $chars .= self::$symbols;
        }
        if ( $params["capitalizeLetters"] ) {
            if ( $params['useHex'] ) {
                $chars .= self::$capitalHex;
            }
            else {
                $chars .= self::$capitalLetters;
            }
        }

        $numChars = strlen($chars);

        for ($i=0; $i < $numberOfPasswords; $i++) {

            $passwordLength = rand($params["minPasswordLength"], $params["maxPasswordLength"]);
            $password = '';

            for ($j=1; $j <= $passwordLength; $j++) {
                $password .= substr($chars, rand(0, $numChars - 1), 1);
            }

            if ( $params["requireLetters"] && !preg_match("/[a-z]/", $password) ) {
                $password = self::additionalSymbol(self::$lowercaseLetters, $password, $passwordLength);
            }

            if ( $params["requireNumbers"] && !preg_match("/[0-9]/", $password) ) {
                $password = self::additionalSymbol(self::$number, $password, $passwordLength);
            }

            if ( $params["requireSymbols"] && !preg_match("/[\,\.\'\"\/\:\;\&\!\@\#\%\*]/", $password) ) {
                $password = self::additionalSymbol(self::$symbols, $password, $passwordLength);
            }

            if ( $params['doMD5'] ) {
                $password = array(
                    'pass' => $password,
                    'md5'  => md5($password),
                );
            }

            $passwords[] = $password;
        }
        return $passwords;
    }

    protected static function additionalSymbol($type, $password, $passwordLength) {
        $numSymbols = strlen($type);
        $s = substr($type, rand(0, $numSymbols - 1), 1);
        $randomPosition = rand(0, $passwordLength);
        $password = substr($password, 0, $randomPosition) . $s . substr( $password, $randomPosition, $passwordLength );
        return $password;
    }
}
