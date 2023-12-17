*** Settings ***
Documentation       Initial setup required for any test suite
Resource            ../../resources/browser.resource
Suite Setup         Initial setup
Suite Teardown      Close All Browsers    
