<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step  name="main"
    xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step" 
    xmlns:cx="http://xmlcalabash.com/ns/extensions"
    version="1.0">
    
    <p:input port="source">
        <p:inline>
            <doc>Hello world!</doc>
        </p:inline>
    </p:input>
    
    <p:output port="result"/>
    
    <p:import href="http://xmlcalabash.com/extension/steps/library-1.0.xpl"/>
    
    <p:store href="file:///mnt/win7-work/SGML/DTD/cosml/test-wait.xml" name="save">
        
    </p:store>
    
    <cx:wait-for-update cx:depends-on="save" href="file:///mnt/win7-work/SGML/DTD/cosml/test-wait.xml" pause-before="2"/>
    
    <p:identity name="id2"/>
</p:declare-step>