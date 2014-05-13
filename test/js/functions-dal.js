module.exports = {
	'VD Test': function (test) {
	  test
	  	.open('http://cdecurate-qa.nci.nih.gov')
	    .type('#keyword', 'Anastrozole Administrered Medication Route of Administration Type\n')
          .assert.exists('body', 'A nonsteroidal inhibitor of estrogen synthesis that resembles paclitaxel in chemical structure.')
        .click('body > div:nth-child(11) > table > tbody > tr:nth-child(2) > td:nth-child(2) > a')    //click on Login hyperlink
        .type('#Username', 'GUEST')
        .type('#Password', 'Nci_gue5t\n')
		.query('td.menuItemNormal:nth-child(2)')	//select Create
        .click()
		.query('#createMenu > dl:nth-child(3)')		//select VD
        .click()
		.done();
	}
    ,
    'DEC Test': function (test) {
        test
            .open('http://cdecurate-qa.nci.nih.gov')
            .type('#keyword', 'Anastrozole Administrered Medication Route of Administration Type\n')
            .assert.exists('body', 'A nonsteroidal inhibitor of estrogen synthesis that resembles paclitaxel in chemical structure.')
            .click('body > div:nth-child(11) > table > tbody > tr:nth-child(2) > td:nth-child(2) > a')    //click on Login hyperlink
            .type('#Username', 'GUEST')
            .type('#Password', 'Nci_gue5t\n')
            .query('td.menuItemNormal:nth-child(2)')	//select Create
            .click()
            .query('#createMenu > dl:nth-child(3)')		//select VD
            .click()
            .done();
    }
};