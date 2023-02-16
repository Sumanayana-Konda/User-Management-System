const app = require('./server');
const request = require('supertest');
const { response } = require('./server');
const expect = require('chai').expect;
describe('Test API Health End Point and API Validations', () => {
  it(' Test API Health End Point', (done) => {
    request(app)
      .get('/healthz')
      .expect(200)
      .end((err, res) => {
        if (err){ 
          done(err);
         }
         else{
        done();}
      });
    
  });

  it(' Test API Health End Point', (done) => {
    request(app)
      .get('/v1/user/2')
      .expect(403)
      .end((err, res) => {
        if (err){ 
          done(err);
         }
         else{
        done();}
      });
    
  });

  it(' Test API Health End Point', (done) => {
    request(app)
      .put('/v1/user/2')
      .expect(400)
      .end((err, res) => {
        if (err){ 
          done(err);
         }
         else{
        done();}
      });
    
  });

});



